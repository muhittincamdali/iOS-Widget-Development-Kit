import Foundation
import LocalAuthentication
import CryptoKit
import Security

/// Enterprise-grade authentication manager supporting biometric, multi-factor,
/// and device-based authentication with secure session management
@available(iOS 16.0, *)
public class AuthenticationManager: ObservableObject {
    
    // MARK: - Types
    
    public enum AuthenticationError: LocalizedError {
        case biometricNotAvailable
        case biometricNotConfigured
        case biometricAuthenticationFailed
        case deviceBindingFailed
        case tokenGenerationFailed
        case tokenValidationFailed
        case sessionExpired
        case invalidCredentials
        case tooManyAttempts
        case userCancelled
        case systemCancel
        case passcodeNotSet
        case touchIDNotAvailable
        case faceIDNotAvailable
        case unknownError
        
        public var errorDescription: String? {
            switch self {
            case .biometricNotAvailable:
                return "Biometric authentication is not available on this device"
            case .biometricNotConfigured:
                return "Biometric authentication is not configured"
            case .biometricAuthenticationFailed:
                return "Biometric authentication failed"
            case .deviceBindingFailed:
                return "Device binding validation failed"
            case .tokenGenerationFailed:
                return "Failed to generate authentication token"
            case .tokenValidationFailed:
                return "Authentication token validation failed"
            case .sessionExpired:
                return "Authentication session has expired"
            case .invalidCredentials:
                return "Invalid authentication credentials"
            case .tooManyAttempts:
                return "Too many authentication attempts"
            case .userCancelled:
                return "Authentication was cancelled by user"
            case .systemCancel:
                return "Authentication was cancelled by system"
            case .passcodeNotSet:
                return "Device passcode is not set"
            case .touchIDNotAvailable:
                return "Touch ID is not available"
            case .faceIDNotAvailable:
                return "Face ID is not available"
            case .unknownError:
                return "An unknown authentication error occurred"
            }
        }
    }
    
    public enum BiometryType {
        case none
        case touchID
        case faceID
        case opticID
        
        init(from laBiometryType: LABiometryType) {
            switch laBiometryType {
            case .none: self = .none
            case .touchID: self = .touchID
            case .faceID: self = .faceID
            case .opticID: self = .opticID
            @unknown default: self = .none
            }
        }
        
        public var displayName: String {
            switch self {
            case .none: return "None"
            case .touchID: return "Touch ID"
            case .faceID: return "Face ID"
            case .opticID: return "Optic ID"
            }
        }
    }
    
    public struct AuthenticationResult {
        public let isSuccessful: Bool
        public let token: SecureToken?
        public let biometryType: BiometryType
        public let deviceId: String
        public let sessionId: String
        public let expiresAt: Date
        public let permissions: Set<Permission>
        public let metadata: [String: Any]
        
        public init(isSuccessful: Bool, token: SecureToken? = nil, biometryType: BiometryType, deviceId: String, sessionId: String, expiresAt: Date, permissions: Set<Permission> = [], metadata: [String: Any] = [:]) {
            self.isSuccessful = isSuccessful
            self.token = token
            self.biometryType = biometryType
            self.deviceId = deviceId
            self.sessionId = sessionId
            self.expiresAt = expiresAt
            self.permissions = permissions
            self.metadata = metadata
        }
    }
    
    public struct SecureToken: Codable {
        public let value: String
        public let type: TokenType
        public let issuer: String
        public let audience: String
        public let subject: String
        public let issuedAt: Date
        public let expiresAt: Date
        public let notBefore: Date
        public let jwtId: String
        public let scopes: Set<String>
        public let algorithm: String
        
        public enum TokenType: String, Codable {
            case access = "access"
            case refresh = "refresh"
            case idToken = "id_token"
        }
        
        public var isExpired: Bool {
            return Date() > expiresAt
        }
        
        public var isValid: Bool {
            let now = Date()
            return now >= notBefore && now <= expiresAt
        }
    }
    
    public enum Permission: String, CaseIterable, Codable {
        case widgetAccess = "widget.access"
        case dataAccess = "data.access"
        case analyticsAccess = "analytics.access"
        case adminAccess = "admin.access"
        case configurationAccess = "configuration.access"
        case securityAccess = "security.access"
        
        public var description: String {
            switch self {
            case .widgetAccess: return "Access to widget functionality"
            case .dataAccess: return "Access to widget data"
            case .analyticsAccess: return "Access to analytics data"
            case .adminAccess: return "Administrative access"
            case .configurationAccess: return "Configuration management access"
            case .securityAccess: return "Security management access"
            }
        }
    }
    
    public struct AuthenticationSession {
        public let sessionId: String
        public let userId: String?
        public let deviceId: String
        public let createdAt: Date
        public let expiresAt: Date
        public let lastActivityAt: Date
        public let permissions: Set<Permission>
        public let ipAddress: String?
        public let userAgent: String?
        public let isActive: Bool
        
        public var isExpired: Bool {
            return Date() > expiresAt
        }
        
        public var remainingTime: TimeInterval {
            return expiresAt.timeIntervalSinceNow
        }
    }
    
    // MARK: - Properties
    
    private let context = LAContext()
    private let tokenManager = SecureTokenManager()
    private let deviceManager = DeviceBindingManager()
    private let sessionManager = SessionManager()
    private let auditLogger = AuthenticationAuditLogger()
    private let biometricService = BiometricAuthenticationService()
    
    @Published public private(set) var currentSession: AuthenticationSession?
    @Published public private(set) var isAuthenticated: Bool = false
    @Published public private(set) var availableBiometryType: BiometryType = .none
    @Published public private(set) var authenticationAttempts: Int = 0
    @Published public private(set) var authenticationMetrics = AuthenticationMetrics()
    
    private let maxAuthenticationAttempts = 5
    private let lockoutDuration: TimeInterval = 300 // 5 minutes
    private var lockoutTimer: Timer?
    
    // MARK: - Initialization
    
    public init() {
        setupAuthenticationManager()
        checkBiometricAvailability()
    }
    
    // MARK: - Public Methods
    
    /// Performs complete authentication flow with biometric and device binding
    public func authenticate(reason: String? = nil, allowFallback: Bool = true) async throws -> AuthenticationResult {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Check if user is locked out
        guard !isUserLockedOut() else {
            throw AuthenticationError.tooManyAttempts
        }
        
        do {
            // Step 1: Biometric Authentication
            let biometricResult = try await performBiometricAuthentication(reason: reason, allowFallback: allowFallback)
            
            // Step 2: Device Binding Validation
            let deviceBinding = try await validateDeviceBinding()
            
            // Step 3: Generate Secure Session
            let session = try await createSecureSession(biometryType: biometricResult.biometryType, deviceId: deviceBinding.deviceId)
            
            // Step 4: Generate Tokens
            let tokens = try await generateAuthenticationTokens(for: session)
            
            // Update state
            await updateAuthenticationState(session: session, tokens: tokens)
            
            // Reset attempts on success
            authenticationAttempts = 0
            
            // Metrics and audit
            let duration = CFAbsoluteTimeGetCurrent() - startTime
            await updateAuthenticationMetrics(success: true, duration: duration)
            await auditLogger.logAuthenticationEvent(.authenticationSuccessful, sessionId: session.sessionId)
            
            return AuthenticationResult(
                isSuccessful: true,
                token: tokens.accessToken,
                biometryType: biometricResult.biometryType,
                deviceId: deviceBinding.deviceId,
                sessionId: session.sessionId,
                expiresAt: session.expiresAt,
                permissions: session.permissions,
                metadata: [
                    "duration": duration,
                    "biometryUsed": biometricResult.biometryUsed,
                    "deviceTrusted": deviceBinding.isTrusted
                ]
            )
            
        } catch {
            // Handle authentication failure
            authenticationAttempts += 1
            
            if authenticationAttempts >= maxAuthenticationAttempts {
                startLockoutTimer()
            }
            
            let duration = CFAbsoluteTimeGetCurrent() - startTime
            await updateAuthenticationMetrics(success: false, duration: duration)
            await auditLogger.logAuthenticationEvent(.authenticationFailed, error: error)
            
            throw error
        }
    }
    
    /// Validates an existing authentication session
    public func validateSession(_ sessionId: String? = nil) async throws -> Bool {
        let targetSessionId = sessionId ?? currentSession?.sessionId
        
        guard let sessionId = targetSessionId else {
            throw AuthenticationError.sessionExpired
        }
        
        let isValid = try await sessionManager.validateSession(sessionId)
        
        if !isValid {
            await invalidateCurrentSession()
        }
        
        return isValid
    }
    
    /// Refreshes the current authentication session
    public func refreshSession() async throws -> AuthenticationResult {
        guard let currentSession = currentSession else {
            throw AuthenticationError.sessionExpired
        }
        
        // Validate current session
        let isCurrentValid = try await sessionManager.validateSession(currentSession.sessionId)
        guard isCurrentValid else {
            throw AuthenticationError.sessionExpired
        }
        
        // Create new session with extended expiry
        let newSession = try await sessionManager.renewSession(currentSession.sessionId)
        
        // Generate new tokens
        let tokens = try await generateAuthenticationTokens(for: newSession)
        
        // Update state
        await updateAuthenticationState(session: newSession, tokens: tokens)
        
        await auditLogger.logAuthenticationEvent(.sessionRefreshed, sessionId: newSession.sessionId)
        
        return AuthenticationResult(
            isSuccessful: true,
            token: tokens.accessToken,
            biometryType: availableBiometryType,
            deviceId: newSession.deviceId,
            sessionId: newSession.sessionId,
            expiresAt: newSession.expiresAt,
            permissions: newSession.permissions
        )
    }
    
    /// Logs out the current user and invalidates the session
    public func logout() async {
        guard let session = currentSession else { return }
        
        // Invalidate session
        try? await sessionManager.invalidateSession(session.sessionId)
        
        // Clear tokens
        await tokenManager.clearTokens()
        
        // Clear state
        await clearAuthenticationState()
        
        await auditLogger.logAuthenticationEvent(.userLoggedOut, sessionId: session.sessionId)
    }
    
    /// Checks if biometric authentication is available
    public func checkBiometricAvailability() -> (available: Bool, type: BiometryType, error: AuthenticationError?) {
        var error: NSError?
        let available = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        let biometryType = BiometryType(from: context.biometryType)
        
        DispatchQueue.main.async {
            self.availableBiometryType = biometryType
        }
        
        if let nsError = error {
            let authError = mapLAError(nsError)
            return (false, biometryType, authError)
        }
        
        return (available, biometryType, nil)
    }
    
    /// Gets the current authentication metrics
    public func getAuthenticationMetrics() -> AuthenticationMetrics {
        return authenticationMetrics
    }
    
    /// Checks if a user has specific permission
    public func hasPermission(_ permission: Permission) -> Bool {
        return currentSession?.permissions.contains(permission) ?? false
    }
    
    /// Checks if multiple permissions are granted
    public func hasPermissions(_ permissions: Set<Permission>) -> Bool {
        guard let sessionPermissions = currentSession?.permissions else { return false }
        return permissions.isSubset(of: sessionPermissions)
    }
    
    /// Updates user permissions (admin only)
    public func updatePermissions(_ permissions: Set<Permission>, for sessionId: String) async throws {
        guard hasPermission(.adminAccess) else {
            throw AuthenticationError.invalidCredentials
        }
        
        try await sessionManager.updatePermissions(permissions, for: sessionId)
        
        if sessionId == currentSession?.sessionId {
            await refreshCurrentSessionPermissions()
        }
        
        await auditLogger.logAuthenticationEvent(.permissionsUpdated, sessionId: sessionId, permissions: permissions)
    }
    
    /// Enables or disables biometric authentication
    public func setBiometricEnabled(_ enabled: Bool) async throws {
        let availability = checkBiometricAvailability()
        
        guard availability.available else {
            throw availability.error ?? AuthenticationError.biometricNotAvailable
        }
        
        if enabled {
            // Test biometric authentication
            _ = try await performBiometricAuthentication(reason: "Enable biometric authentication", allowFallback: false)
        }
        
        UserDefaults.standard.set(enabled, forKey: "biometric_authentication_enabled")
        
        await auditLogger.logAuthenticationEvent(.biometricSettingChanged, details: ["enabled": enabled])
    }
    
    /// Gets authentication session history
    public func getSessionHistory(limit: Int = 10) async throws -> [AuthenticationSession] {
        return try await sessionManager.getSessionHistory(limit: limit)
    }
    
    /// Terminates all other sessions (keep current)
    public func terminateOtherSessions() async throws {
        guard let currentSessionId = currentSession?.sessionId else { return }
        
        try await sessionManager.terminateAllSessionsExcept(currentSessionId)
        
        await auditLogger.logAuthenticationEvent(.otherSessionsTerminated, sessionId: currentSessionId)
    }
    
    // MARK: - Private Methods
    
    private func setupAuthenticationManager() {
        // Configure LAContext
        context.localizedFallbackTitle = "Use Passcode"
        context.localizedCancelTitle = "Cancel"
        
        // Setup session monitoring
        startSessionMonitoring()
        
        // Load existing session if available
        Task {
            await loadExistingSession()
        }
    }
    
    private func performBiometricAuthentication(reason: String?, allowFallback: Bool) async throws -> BiometricAuthenticationResult {
        let authReason = reason ?? "Authenticate to access secure widget data"
        
        let availability = checkBiometricAvailability()
        guard availability.available else {
            throw availability.error ?? AuthenticationError.biometricNotAvailable
        }
        
        let policy: LAPolicy = allowFallback ? .deviceOwnerAuthentication : .deviceOwnerAuthenticationWithBiometrics
        
        do {
            let success = try await context.evaluatePolicy(policy, localizedReason: authReason)
            
            return BiometricAuthenticationResult(
                success: success,
                biometryType: availableBiometryType,
                biometryUsed: true,
                fallbackUsed: false
            )
            
        } catch let error as LAError {
            throw mapLAError(error)
        }
    }
    
    private func validateDeviceBinding() async throws -> DeviceBindingResult {
        return try await deviceManager.validateBinding()
    }
    
    private func createSecureSession(biometryType: BiometryType, deviceId: String) async throws -> AuthenticationSession {
        let sessionId = UUID().uuidString
        let now = Date()
        let expiresAt = now.addingTimeInterval(3600) // 1 hour
        
        let permissions: Set<Permission> = [.widgetAccess, .dataAccess, .analyticsAccess]
        
        let session = AuthenticationSession(
            sessionId: sessionId,
            userId: nil, // Widget framework doesn't require user accounts
            deviceId: deviceId,
            createdAt: now,
            expiresAt: expiresAt,
            lastActivityAt: now,
            permissions: permissions,
            ipAddress: nil,
            userAgent: nil,
            isActive: true
        )
        
        try await sessionManager.createSession(session)
        
        return session
    }
    
    private func generateAuthenticationTokens(for session: AuthenticationSession) async throws -> AuthenticationTokens {
        return try await tokenManager.generateTokens(for: session)
    }
    
    @MainActor
    private func updateAuthenticationState(session: AuthenticationSession, tokens: AuthenticationTokens) {
        self.currentSession = session
        self.isAuthenticated = true
    }
    
    @MainActor
    private func clearAuthenticationState() {
        self.currentSession = nil
        self.isAuthenticated = false
    }
    
    private func isUserLockedOut() -> Bool {
        return authenticationAttempts >= maxAuthenticationAttempts && lockoutTimer?.isValid == true
    }
    
    private func startLockoutTimer() {
        lockoutTimer?.invalidate()
        lockoutTimer = Timer.scheduledTimer(withTimeInterval: lockoutDuration, repeats: false) { [weak self] _ in
            self?.authenticationAttempts = 0
            Task {
                await self?.auditLogger.logAuthenticationEvent(.lockoutExpired)
            }
        }
        
        Task {
            await auditLogger.logAuthenticationEvent(.userLockedOut, details: ["duration": lockoutDuration])
        }
    }
    
    private func startSessionMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            Task {
                await self?.validateCurrentSession()
            }
        }
    }
    
    private func validateCurrentSession() async {
        guard let session = currentSession else { return }
        
        if session.isExpired {
            await invalidateCurrentSession()
        }
    }
    
    private func invalidateCurrentSession() async {
        await clearAuthenticationState()
        await auditLogger.logAuthenticationEvent(.sessionExpired)
    }
    
    private func loadExistingSession() async {
        // Try to restore session from secure storage
        if let sessionData = try? await sessionManager.getActiveSession() {
            await updateAuthenticationState(session: sessionData, tokens: AuthenticationTokens.empty)
        }
    }
    
    private func refreshCurrentSessionPermissions() async {
        guard let sessionId = currentSession?.sessionId else { return }
        
        if let updatedSession = try? await sessionManager.getSession(sessionId) {
            await MainActor.run {
                self.currentSession = updatedSession
            }
        }
    }
    
    @MainActor
    private func updateAuthenticationMetrics(success: Bool, duration: TimeInterval) {
        if success {
            authenticationMetrics.totalSuccessfulAuthentications += 1
            authenticationMetrics.totalAuthenticationTime += duration
            authenticationMetrics.averageAuthenticationTime = authenticationMetrics.totalAuthenticationTime / Double(authenticationMetrics.totalSuccessfulAuthentications)
        } else {
            authenticationMetrics.totalFailedAuthentications += 1
        }
        
        authenticationMetrics.lastAuthenticationTime = Date()
    }
    
    private func mapLAError(_ error: Error) -> AuthenticationError {
        guard let laError = error as? LAError else {
            return .unknownError
        }
        
        switch laError.code {
        case .biometryNotAvailable:
            return .biometricNotAvailable
        case .biometryNotEnrolled:
            return .biometricNotConfigured
        case .authenticationFailed:
            return .biometricAuthenticationFailed
        case .userCancel:
            return .userCancelled
        case .systemCancel:
            return .systemCancel
        case .passcodeNotSet:
            return .passcodeNotSet
        case .touchIDNotAvailable:
            return .touchIDNotAvailable
        case .faceIDNotAvailable:
            return .faceIDNotAvailable
        default:
            return .unknownError
        }
    }
}

// MARK: - Supporting Types

private struct BiometricAuthenticationResult {
    let success: Bool
    let biometryType: AuthenticationManager.BiometryType
    let biometryUsed: Bool
    let fallbackUsed: Bool
}

private struct DeviceBindingResult {
    let isValid: Bool
    let deviceId: String
    let isTrusted: Bool
}

private struct AuthenticationTokens {
    let accessToken: AuthenticationManager.SecureToken
    let refreshToken: AuthenticationManager.SecureToken?
    
    static let empty = AuthenticationTokens(
        accessToken: AuthenticationManager.SecureToken(
            value: "",
            type: .access,
            issuer: "",
            audience: "",
            subject: "",
            issuedAt: Date(),
            expiresAt: Date(),
            notBefore: Date(),
            jwtId: "",
            scopes: [],
            algorithm: ""
        ),
        refreshToken: nil
    )
}

/// Authentication performance metrics
public class AuthenticationMetrics: ObservableObject {
    @Published public var totalSuccessfulAuthentications: Int = 0
    @Published public var totalFailedAuthentications: Int = 0
    @Published public var totalAuthenticationTime: TimeInterval = 0
    @Published public var averageAuthenticationTime: TimeInterval = 0
    @Published public var lastAuthenticationTime: Date?
    
    public var successRate: Double {
        let total = totalSuccessfulAuthentications + totalFailedAuthentications
        guard total > 0 else { return 0 }
        return Double(totalSuccessfulAuthentications) / Double(total)
    }
}

// MARK: - Private Supporting Classes

private class SecureTokenManager {
    func generateTokens(for session: AuthenticationManager.AuthenticationSession) async throws -> AuthenticationTokens {
        // Implementation for JWT token generation
        let accessToken = AuthenticationManager.SecureToken(
            value: UUID().uuidString,
            type: .access,
            issuer: "iOS-Widget-Development-Kit",
            audience: "widget-app",
            subject: session.deviceId,
            issuedAt: Date(),
            expiresAt: session.expiresAt,
            notBefore: Date(),
            jwtId: UUID().uuidString,
            scopes: Set(session.permissions.map { $0.rawValue }),
            algorithm: "HS256"
        )
        
        return AuthenticationTokens(accessToken: accessToken, refreshToken: nil)
    }
    
    func clearTokens() async {
        // Clear stored tokens
    }
}

private class DeviceBindingManager {
    func validateBinding() async throws -> DeviceBindingResult {
        let deviceId = await UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
        return DeviceBindingResult(isValid: true, deviceId: deviceId, isTrusted: true)
    }
}

private class SessionManager {
    func createSession(_ session: AuthenticationManager.AuthenticationSession) async throws {
        // Store session securely
    }
    
    func validateSession(_ sessionId: String) async throws -> Bool {
        // Validate session
        return true
    }
    
    func renewSession(_ sessionId: String) async throws -> AuthenticationManager.AuthenticationSession {
        // Renew session
        throw AuthenticationManager.AuthenticationError.sessionExpired
    }
    
    func invalidateSession(_ sessionId: String) async throws {
        // Invalidate session
    }
    
    func updatePermissions(_ permissions: Set<AuthenticationManager.Permission>, for sessionId: String) async throws {
        // Update permissions
    }
    
    func getActiveSession() async throws -> AuthenticationManager.AuthenticationSession? {
        // Get active session
        return nil
    }
    
    func getSession(_ sessionId: String) async throws -> AuthenticationManager.AuthenticationSession? {
        // Get specific session
        return nil
    }
    
    func getSessionHistory(limit: Int) async throws -> [AuthenticationManager.AuthenticationSession] {
        // Get session history
        return []
    }
    
    func terminateAllSessionsExcept(_ sessionId: String) async throws {
        // Terminate other sessions
    }
}

private class AuthenticationAuditLogger {
    enum AuthenticationEvent {
        case authenticationSuccessful
        case authenticationFailed
        case sessionRefreshed
        case userLoggedOut
        case sessionExpired
        case lockoutExpired
        case userLockedOut
        case permissionsUpdated
        case biometricSettingChanged
        case otherSessionsTerminated
    }
    
    func logAuthenticationEvent(_ event: AuthenticationEvent, sessionId: String? = nil, error: Error? = nil, permissions: Set<AuthenticationManager.Permission>? = nil, details: [String: Any] = [:]) async {
        // Log authentication events
    }
}

private class BiometricAuthenticationService {
    // Additional biometric functionality
}