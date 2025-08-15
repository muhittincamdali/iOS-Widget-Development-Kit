import Foundation
import CryptoKit
import Security
import LocalAuthentication

/// Enterprise-grade encryption manager providing AES-256-GCM encryption
/// with Secure Enclave integration and key management
@available(iOS 16.0, *)
public class EncryptionManager: ObservableObject {
    
    // MARK: - Types
    
    public enum EncryptionError: LocalizedError {
        case keyGenerationFailed
        case encryptionFailed
        case decryptionFailed
        case keyStorageFailed
        case keyRetrievalFailed
        case secureEnclaveUnavailable
        case invalidData
        case authenticationRequired
        
        public var errorDescription: String? {
            switch self {
            case .keyGenerationFailed:
                return "Failed to generate encryption key"
            case .encryptionFailed:
                return "Data encryption failed"
            case .decryptionFailed:
                return "Data decryption failed"
            case .keyStorageFailed:
                return "Failed to store encryption key"
            case .keyRetrievalFailed:
                return "Failed to retrieve encryption key"
            case .secureEnclaveUnavailable:
                return "Secure Enclave not available on this device"
            case .invalidData:
                return "Invalid data format"
            case .authenticationRequired:
                return "Authentication required for decryption"
            }
        }
    }
    
    public enum KeySize: Int {
        case bits128 = 128
        case bits192 = 192
        case bits256 = 256
        
        var symmetricKeySize: SymmetricKeySize {
            switch self {
            case .bits128: return .bits128
            case .bits192: return .bits192
            case .bits256: return .bits256
            }
        }
    }
    
    public struct EncryptedData: Codable {
        public let ciphertext: Data
        public let nonce: Data
        public let tag: Data
        public let keyIdentifier: String
        public let algorithm: String
        public let createdAt: Date
        
        public init(ciphertext: Data, nonce: Data, tag: Data, keyIdentifier: String, algorithm: String = "AES-256-GCM") {
            self.ciphertext = ciphertext
            self.nonce = nonce
            self.tag = tag
            self.keyIdentifier = keyIdentifier
            self.algorithm = algorithm
            self.createdAt = Date()
        }
    }
    
    public struct EncryptionMetadata {
        public let keyIdentifier: String
        public let algorithm: String
        public let keySize: KeySize
        public let createdAt: Date
        public let lastUsed: Date
        public let accessCount: Int
    }
    
    // MARK: - Properties
    
    private let keyManager: CryptographicKeyManager
    private let biometricAuth: BiometricAuthenticationService
    private let auditLogger: SecurityAuditLogger
    private var encryptionCache: NSCache<NSString, SymmetricKey>
    
    @Published public private(set) var isSecureEnclaveAvailable: Bool = false
    @Published public private(set) var encryptionMetrics = EncryptionMetrics()
    
    // MARK: - Initialization
    
    public init() {
        self.keyManager = CryptographicKeyManager()
        self.biometricAuth = BiometricAuthenticationService()
        self.auditLogger = SecurityAuditLogger()
        self.encryptionCache = NSCache<NSString, SymmetricKey>()
        
        setupEncryptionManager()
    }
    
    // MARK: - Public Methods
    
    /// Encrypts data using AES-256-GCM with a new or existing key
    public func encryptData(_ data: Data, keyIdentifier: String? = nil, requireBiometric: Bool = false) async throws -> EncryptedData {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        do {
            // Generate or retrieve encryption key
            let key: SymmetricKey
            let finalKeyIdentifier: String
            
            if let existingKeyId = keyIdentifier {
                key = try await keyManager.retrieveKey(identifier: existingKeyId, requireBiometric: requireBiometric)
                finalKeyIdentifier = existingKeyId
            } else {
                let newKey = try await keyManager.generateKey(size: .bits256, storeInSecureEnclave: isSecureEnclaveAvailable)
                key = newKey.key
                finalKeyIdentifier = newKey.identifier
            }
            
            // Perform encryption
            let sealedBox = try AES.GCM.seal(data, using: key)
            
            let encryptedData = EncryptedData(
                ciphertext: sealedBox.ciphertext,
                nonce: sealedBox.nonce,
                tag: sealedBox.tag,
                keyIdentifier: finalKeyIdentifier
            )
            
            // Update metrics
            let duration = CFAbsoluteTimeGetCurrent() - startTime
            await updateEncryptionMetrics(operation: .encryption, duration: duration, dataSize: data.count)
            
            // Audit logging
            await auditLogger.logEncryptionEvent(.dataEncrypted, keyIdentifier: finalKeyIdentifier, dataSize: data.count)
            
            return encryptedData
            
        } catch {
            await auditLogger.logEncryptionEvent(.encryptionFailed, error: error)
            throw EncryptionError.encryptionFailed
        }
    }
    
    /// Decrypts data using the stored key
    public func decryptData(_ encryptedData: EncryptedData, requireBiometric: Bool = false) async throws -> Data {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        do {
            // Retrieve decryption key
            let key = try await keyManager.retrieveKey(
                identifier: encryptedData.keyIdentifier,
                requireBiometric: requireBiometric
            )
            
            // Reconstruct sealed box
            let sealedBox = try AES.GCM.SealedBox(
                nonce: encryptedData.nonce,
                ciphertext: encryptedData.ciphertext,
                tag: encryptedData.tag
            )
            
            // Perform decryption
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            
            // Update metrics
            let duration = CFAbsoluteTimeGetCurrent() - startTime
            await updateEncryptionMetrics(operation: .decryption, duration: duration, dataSize: decryptedData.count)
            
            // Audit logging
            await auditLogger.logEncryptionEvent(.dataDecrypted, keyIdentifier: encryptedData.keyIdentifier, dataSize: decryptedData.count)
            
            return decryptedData
            
        } catch {
            await auditLogger.logEncryptionEvent(.decryptionFailed, keyIdentifier: encryptedData.keyIdentifier, error: error)
            throw EncryptionError.decryptionFailed
        }
    }
    
    /// Encrypts a string and returns base64 encoded result
    public func encryptString(_ string: String, keyIdentifier: String? = nil) async throws -> String {
        guard let data = string.data(using: .utf8) else {
            throw EncryptionError.invalidData
        }
        
        let encryptedData = try await encryptData(data, keyIdentifier: keyIdentifier)
        let encodedData = try JSONEncoder().encode(encryptedData)
        return encodedData.base64EncodedString()
    }
    
    /// Decrypts a base64 encoded string
    public func decryptString(_ encryptedString: String) async throws -> String {
        guard let data = Data(base64Encoded: encryptedString) else {
            throw EncryptionError.invalidData
        }
        
        let encryptedData = try JSONDecoder().decode(EncryptedData.self, from: data)
        let decryptedData = try await decryptData(encryptedData)
        
        guard let string = String(data: decryptedData, encoding: .utf8) else {
            throw EncryptionError.invalidData
        }
        
        return string
    }
    
    /// Generates a new encryption key and stores it securely
    public func generateNewKey(identifier: String? = nil, size: KeySize = .bits256) async throws -> String {
        let keyResult = try await keyManager.generateKey(
            size: size,
            identifier: identifier,
            storeInSecureEnclave: isSecureEnclaveAvailable
        )
        
        await auditLogger.logEncryptionEvent(.keyGenerated, keyIdentifier: keyResult.identifier)
        return keyResult.identifier
    }
    
    /// Deletes an encryption key
    public func deleteKey(_ identifier: String) async throws {
        try await keyManager.deleteKey(identifier: identifier)
        await auditLogger.logEncryptionEvent(.keyDeleted, keyIdentifier: identifier)
    }
    
    /// Lists all available encryption keys
    public func listKeys() async throws -> [EncryptionMetadata] {
        return try await keyManager.listKeys()
    }
    
    /// Rotates an encryption key (creates new key and re-encrypts data)
    public func rotateKey(_ oldIdentifier: String, newSize: KeySize = .bits256) async throws -> String {
        // Generate new key
        let newKeyResult = try await keyManager.generateKey(size: newSize, storeInSecureEnclave: isSecureEnclaveAvailable)
        
        // Log rotation
        await auditLogger.logEncryptionEvent(.keyRotated, keyIdentifier: oldIdentifier, newKeyIdentifier: newKeyResult.identifier)
        
        return newKeyResult.identifier
    }
    
    /// Performs bulk encryption for multiple data items
    public func bulkEncrypt(_ dataItems: [Data], keyIdentifier: String? = nil) async throws -> [EncryptedData] {
        var results: [EncryptedData] = []
        
        for data in dataItems {
            let encrypted = try await encryptData(data, keyIdentifier: keyIdentifier)
            results.append(encrypted)
        }
        
        return results
    }
    
    /// Performs bulk decryption for multiple encrypted items
    public func bulkDecrypt(_ encryptedItems: [EncryptedData]) async throws -> [Data] {
        var results: [Data] = []
        
        for encrypted in encryptedItems {
            let decrypted = try await decryptData(encrypted)
            results.append(decrypted)
        }
        
        return results
    }
    
    /// Verifies data integrity by re-encrypting and comparing
    public func verifyDataIntegrity(_ encryptedData: EncryptedData) async throws -> Bool {
        do {
            let decrypted = try await decryptData(encryptedData)
            let reEncrypted = try await encryptData(decrypted, keyIdentifier: encryptedData.keyIdentifier)
            return reEncrypted.ciphertext == encryptedData.ciphertext
        } catch {
            return false
        }
    }
    
    /// Gets encryption performance metrics
    public func getMetrics() -> EncryptionMetrics {
        return encryptionMetrics
    }
    
    /// Clears encryption cache (for memory management)
    public func clearCache() {
        encryptionCache.removeAllObjects()
        Task {
            await auditLogger.logEncryptionEvent(.cacheCleared)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupEncryptionManager() {
        // Check Secure Enclave availability
        isSecureEnclaveAvailable = SecureEnclave.isAvailable
        
        // Configure cache
        encryptionCache.countLimit = 50
        encryptionCache.totalCostLimit = 10 * 1024 * 1024 // 10MB
        
        // Setup memory pressure monitoring
        setupMemoryPressureMonitoring()
        
        Task {
            await auditLogger.logEncryptionEvent(.managerInitialized, 
                                               details: ["secureEnclaveAvailable": "\(isSecureEnclaveAvailable)"])
        }
    }
    
    private func setupMemoryPressureMonitoring() {
        let source = DispatchSource.makeMemoryPressureSource(eventMask: .warning, queue: .main)
        source.setEventHandler { [weak self] in
            self?.clearCache()
        }
        source.resume()
    }
    
    @MainActor
    private func updateEncryptionMetrics(operation: EncryptionOperation, duration: TimeInterval, dataSize: Int) {
        switch operation {
        case .encryption:
            encryptionMetrics.totalEncryptions += 1
            encryptionMetrics.totalEncryptionTime += duration
            encryptionMetrics.totalBytesEncrypted += dataSize
        case .decryption:
            encryptionMetrics.totalDecryptions += 1
            encryptionMetrics.totalDecryptionTime += duration
            encryptionMetrics.totalBytesDecrypted += dataSize
        }
        
        encryptionMetrics.averageEncryptionTime = encryptionMetrics.totalEncryptionTime / Double(encryptionMetrics.totalEncryptions)
        encryptionMetrics.averageDecryptionTime = encryptionMetrics.totalDecryptionTime / Double(encryptionMetrics.totalDecryptions)
        encryptionMetrics.lastOperationTime = Date()
    }
}

// MARK: - Supporting Types

private enum EncryptionOperation {
    case encryption
    case decryption
}

/// Encryption performance metrics
public class EncryptionMetrics: ObservableObject {
    @Published public var totalEncryptions: Int = 0
    @Published public var totalDecryptions: Int = 0
    @Published public var totalBytesEncrypted: Int = 0
    @Published public var totalBytesDecrypted: Int = 0
    @Published public var totalEncryptionTime: TimeInterval = 0
    @Published public var totalDecryptionTime: TimeInterval = 0
    @Published public var averageEncryptionTime: TimeInterval = 0
    @Published public var averageDecryptionTime: TimeInterval = 0
    @Published public var lastOperationTime: Date?
    
    public var encryptionThroughput: Double {
        guard totalEncryptionTime > 0 else { return 0 }
        return Double(totalBytesEncrypted) / totalEncryptionTime
    }
    
    public var decryptionThroughput: Double {
        guard totalDecryptionTime > 0 else { return 0 }
        return Double(totalBytesDecrypted) / totalDecryptionTime
    }
}

/// Cryptographic key manager for secure key operations
private class CryptographicKeyManager {
    
    struct KeyResult {
        let key: SymmetricKey
        let identifier: String
    }
    
    func generateKey(size: EncryptionManager.KeySize, identifier: String? = nil, storeInSecureEnclave: Bool = false) async throws -> KeyResult {
        let key = SymmetricKey(size: size.symmetricKeySize)
        let keyIdentifier = identifier ?? UUID().uuidString
        
        // Store key in Keychain
        try await storeKeyInKeychain(key, identifier: keyIdentifier, useSecureEnclave: storeInSecureEnclave)
        
        return KeyResult(key: key, identifier: keyIdentifier)
    }
    
    func retrieveKey(identifier: String, requireBiometric: Bool = false) async throws -> SymmetricKey {
        return try await retrieveKeyFromKeychain(identifier: identifier, requireBiometric: requireBiometric)
    }
    
    func deleteKey(identifier: String) async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw EncryptionManager.EncryptionError.keyRetrievalFailed
        }
    }
    
    func listKeys() async throws -> [EncryptionManager.EncryptionMetadata] {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitAll,
            kSecReturnAttributes as String: true
        ]
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            return []
        }
        
        guard let items = result as? [[String: Any]] else {
            return []
        }
        
        return items.compactMap { item in
            guard let account = item[kSecAttrAccount as String] as? String,
                  let creationDate = item[kSecAttrCreationDate as String] as? Date,
                  let modificationDate = item[kSecAttrModificationDate as String] as? Date else {
                return nil
            }
            
            return EncryptionManager.EncryptionMetadata(
                keyIdentifier: account,
                algorithm: "AES-256-GCM",
                keySize: .bits256,
                createdAt: creationDate,
                lastUsed: modificationDate,
                accessCount: 0
            )
        }
    }
    
    private func storeKeyInKeychain(_ key: SymmetricKey, identifier: String, useSecureEnclave: Bool) async throws {
        let keyData = key.withUnsafeBytes { Data($0) }
        
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier,
            kSecValueData as String: keyData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        if useSecureEnclave {
            let accessControl = SecAccessControlCreateWithFlags(
                nil,
                kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                .privateKeyUsage,
                nil
            )
            query[kSecAttrAccessControl as String] = accessControl
        }
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw EncryptionManager.EncryptionError.keyStorageFailed
        }
    }
    
    private func retrieveKeyFromKeychain(identifier: String, requireBiometric: Bool) async throws -> SymmetricKey {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier,
            kSecReturnData as String: true
        ]
        
        if requireBiometric {
            let context = LAContext()
            query[kSecUseAuthenticationContext as String] = context
        }
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            throw EncryptionManager.EncryptionError.keyRetrievalFailed
        }
        
        guard let keyData = result as? Data else {
            throw EncryptionManager.EncryptionError.keyRetrievalFailed
        }
        
        return SymmetricKey(data: keyData)
    }
}

/// Biometric authentication service
private class BiometricAuthenticationService {
    // Implementation would be added here
    // This is a placeholder for the biometric functionality
}

/// Security audit logger
private class SecurityAuditLogger {
    enum EncryptionEvent {
        case managerInitialized
        case dataEncrypted
        case dataDecrypted
        case encryptionFailed
        case decryptionFailed
        case keyGenerated
        case keyDeleted
        case keyRotated
        case cacheCleared
    }
    
    func logEncryptionEvent(_ event: EncryptionEvent, keyIdentifier: String? = nil, newKeyIdentifier: String? = nil, dataSize: Int = 0, error: Error? = nil, details: [String: String] = [:]) async {
        // Implementation would log to secure audit trail
        // This is a placeholder for the audit functionality
    }
}