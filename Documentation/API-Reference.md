# API Reference

## Core Classes

### Main Framework

The main entry point for the iOS-Widget-Development-Kit framework.

```swift
public class iOS-Widget-Development-Kit {
    public init()
    public func configure()
    public func reset()
}
```

## Configuration

### Options

```swift
public struct Configuration {
    public var debugMode: Bool
    public var logLevel: LogLevel
    public var cacheEnabled: Bool
}
```

## Error Handling

```swift
public enum iOS-Widget-Development-KitError: Error {
    case configurationFailed
    case initializationError
    case runtimeError(String)
}
