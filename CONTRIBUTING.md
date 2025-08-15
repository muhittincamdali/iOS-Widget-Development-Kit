# Contributing to iOS Widget Development Kit

First off, thank you for considering contributing to iOS Widget Development Kit! It's people like you that make this framework such a great tool for the iOS development community.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Process](#development-process)
- [Style Guidelines](#style-guidelines)
- [Testing Requirements](#testing-requirements)
- [Pull Request Process](#pull-request-process)
- [Community](#community)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to [security@widgetkit.dev](mailto:security@widgetkit.dev).

### Our Standards

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

## Getting Started

### Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later
- iOS 16.0 SDK
- Git
- SwiftLint (installed via `brew install swiftlint`)

### Setting Up Your Development Environment

1. **Fork the Repository**
   ```bash
   # Fork via GitHub UI, then clone your fork
   git clone https://github.com/YOUR-USERNAME/iOS-Widget-Development-Kit.git
   cd iOS-Widget-Development-Kit
   ```

2. **Add Upstream Remote**
   ```bash
   git remote add upstream https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
   git fetch upstream
   ```

3. **Install Dependencies**
   ```bash
   # Using Swift Package Manager
   swift package resolve
   
   # Or using Xcode
   open Package.swift
   ```

4. **Run Tests**
   ```bash
   swift test
   
   # Or using xcodebuild
   xcodebuild test -scheme WidgetDevelopmentKit -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
   ```

5. **Install Git Hooks**
   ```bash
   ./scripts/install-hooks.sh
   ```

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible.

**Bug Report Template:**
```markdown
### Description
[Clear and concise description of the bug]

### Steps to Reproduce
1. [First step]
2. [Second step]
3. [And so on...]

### Expected Behavior
[What you expected to happen]

### Actual Behavior
[What actually happened]

### Environment
- iOS Version: [e.g., 17.0]
- Device: [e.g., iPhone 15 Pro]
- Framework Version: [e.g., 3.2.0]
- Xcode Version: [e.g., 15.0]

### Additional Context
[Any other information, screenshots, or code samples]
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- **Use Case**: Explain why this enhancement would be useful
- **Proposed Solution**: Describe your proposed solution
- **Alternatives**: List any alternative solutions or features you've considered
- **Additional Context**: Add any other context or screenshots

### Contributing Code

#### Types of Contributions

1. **Bug Fixes**: Fix reported issues
2. **Features**: Add new functionality
3. **Performance**: Improve performance
4. **Documentation**: Improve or add documentation
5. **Tests**: Add missing tests or improve existing ones
6. **Refactoring**: Improve code structure without changing functionality

#### Finding Issues to Work On

Look for issues labeled:
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `up for grabs` - Open for anyone to work on
- `documentation` - Documentation improvements
- `performance` - Performance improvements
- `security` - Security enhancements

## Development Process

### Branching Strategy

We use Git Flow for our branching strategy:

```
main (stable releases)
  └── develop (integration branch)
        ├── feature/widget-templates
        ├── feature/performance-monitoring
        ├── bugfix/memory-leak
        └── hotfix/critical-security-issue
```

### Creating a Feature Branch

```bash
# Update your local develop branch
git checkout develop
git pull upstream develop

# Create your feature branch
git checkout -b feature/your-feature-name

# Make your changes
git add .
git commit -m "feat: add amazing new feature"

# Push to your fork
git push origin feature/your-feature-name
```

### Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, semicolons, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or modifying tests
- `build`: Build system changes
- `ci`: CI configuration changes
- `chore`: Other changes that don't modify src or test files

**Examples:**
```bash
feat(widgets): add weather widget template
fix(security): resolve keychain access issue
docs(api): update authentication documentation
perf(cache): optimize image caching algorithm
test(integration): add cloud sync tests
```

## Style Guidelines

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and use SwiftLint for enforcement.

#### Key Points:

1. **Naming Conventions**
   ```swift
   // ✅ Good
   class WidgetManager {
       func createWidget(with configuration: WidgetConfiguration) -> Widget
   }
   
   // ❌ Bad
   class widget_manager {
       func CreateWidget(configuration: WidgetConfiguration) -> Widget
   }
   ```

2. **Access Control**
   ```swift
   // Be explicit about access levels
   public class PublicClass {
       public init() {}
       internal func internalMethod() {}
       private func privateMethod() {}
   }
   ```

3. **Error Handling**
   ```swift
   // Use proper error handling
   enum WidgetError: LocalizedError {
       case invalidConfiguration
       case networkUnavailable
       
       var errorDescription: String? {
           switch self {
           case .invalidConfiguration:
               return "Widget configuration is invalid"
           case .networkUnavailable:
               return "Network connection is unavailable"
           }
       }
   }
   ```

## Testing Requirements

### Test Coverage Requirements

- **Minimum Coverage**: 80% for new code
- **Unit Tests**: Required for all public APIs
- **Integration Tests**: Required for cross-module functionality
- **Performance Tests**: Required for performance-critical code
- **UI Tests**: Required for user-facing components

### Writing Tests

```swift
import XCTest
import Quick
import Nimble
@testable import WidgetDevelopmentKit

class WidgetManagerSpec: QuickSpec {
    override func spec() {
        describe("WidgetManager") {
            var sut: WidgetManager!
            
            beforeEach {
                sut = WidgetManager()
            }
            
            afterEach {
                sut = nil
            }
            
            context("when creating a widget") {
                it("should create widget with valid configuration") {
                    let configuration = WidgetConfiguration(
                        type: .weather,
                        size: .medium,
                        displayName: "Test Widget"
                    )
                    
                    expect {
                        try await sut.createWidget(with: configuration)
                    }.toNot(throwError())
                }
            }
        }
    }
}
```

## Pull Request Process

### Before Submitting a PR

1. **Ensure Tests Pass**
   ```bash
   swift test
   ```

2. **Run SwiftLint**
   ```bash
   swiftlint autocorrect
   swiftlint
   ```

3. **Update Documentation**
   - Update README.md if needed
   - Update API documentation
   - Add/update code comments

4. **Check Code Coverage**
   ```bash
   xcodebuild test -scheme WidgetDevelopmentKit -enableCodeCoverage YES
   xcrun llvm-cov report
   ```

### PR Template

```markdown
## Description
[Describe your changes]

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Performance tests pass (if applicable)
- [ ] Manual testing completed

## Checklist
- [ ] My code follows the style guidelines
- [ ] I have performed a self-review
- [ ] I have commented my code where necessary
- [ ] I have updated the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing unit tests pass locally
- [ ] Any dependent changes have been merged

## Screenshots (if applicable)
[Add screenshots here]

## Related Issues
Fixes #(issue number)
```

### Review Process

1. **Automated Checks**: CI/CD pipeline runs automatically
2. **Code Review**: At least one maintainer review required
3. **Testing**: Manual testing by reviewer when applicable
4. **Approval**: Requires approval from maintainer
5. **Merge**: Squash and merge to maintain clean history

## Community

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General discussions and questions
- **Stack Overflow**: Tag questions with `ios-widget-development-kit`
- **Twitter**: Follow [@WidgetKitDev](https://twitter.com/WidgetKitDev)
- **Discord**: Join our [Discord server](https://discord.gg/widgetkit)

### Recognition

Contributors who make significant contributions will be:
- Added to the CONTRIBUTORS.md file
- Mentioned in release notes
- Given special contributor badge in Discord
- Invited to become maintainers (for consistent contributors)

### Getting Help

If you need help, you can:
1. Check the [Documentation](./Documentation)
2. Search existing [Issues](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/issues)
3. Ask in [Discussions](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/discussions)
4. Join our [Discord server](https://discord.gg/widgetkit)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Thank You!

Your contributions to open source, large or small, make projects like this possible. Thank you for taking the time to contribute!

---

**Happy Coding!** 🚀 