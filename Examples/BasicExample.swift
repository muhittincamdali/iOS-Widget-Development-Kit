import Foundation
import iOS-Widget-Development-Kit

/// Basic example demonstrating the core functionality of iOS-Widget-Development-Kit
@main
struct BasicExample {
    static func main() {
        print("🚀 iOS-Widget-Development-Kit Basic Example")
        
        // Initialize the framework
        let framework = iOS-Widget-Development-Kit()
        
        // Configure with default settings
        framework.configure()
        
        print("✅ Framework configured successfully")
        
        // Demonstrate basic functionality
        demonstrateBasicFeatures(framework)
    }
    
    static func demonstrateBasicFeatures(_ framework: iOS-Widget-Development-Kit) {
        print("\n📱 Demonstrating basic features...")
        
        // Add your example code here
        print("🎯 Feature 1: Core functionality")
        print("🎯 Feature 2: Configuration")
        print("🎯 Feature 3: Error handling")
        
        print("\n✨ Basic example completed successfully!")
    }
}
