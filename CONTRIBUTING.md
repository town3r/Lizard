# 🤝 Contributing to Lizard

Thank you for your interest in contributing to Lizard! This document provides guidelines and information for contributors to help maintain code quality and project consistency.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Code of Conduct](#code-of-conduct)
3. [How to Contribute](#how-to-contribute)
4. [Development Setup](#development-setup)
5. [Coding Standards](#coding-standards)
6. [Testing Guidelines](#testing-guidelines)
7. [Pull Request Process](#pull-request-process)
8. [Issue Guidelines](#issue-guidelines)
9. [Documentation Guidelines](#documentation-guidelines)
10. [Release Process](#release-process)

---

## Getting Started

### Prerequisites

Before contributing, ensure you have:

- **macOS 14.0+** (required for iOS/watchOS development)
- **Xcode 15.0+** with iOS 18.0+ and watchOS 9.0+ SDKs
- **Apple Developer Account** (for device testing)
- **Git** configured with your GitHub account
- Basic knowledge of **Swift**, **SwiftUI**, and **SpriteKit**

### Quick Start

```bash
# Fork the repository on GitHub
# Clone your fork
git clone https://github.com/YOUR_USERNAME/Lizard.git
cd Lizard

# Add upstream remote
git remote add upstream https://github.com/town3r/Lizard.git

# Create development branch
git checkout -b feature/your-feature-name

# Open in Xcode and verify build
open Lizard.xcodeproj
```

### First Contribution

For first-time contributors:

1. Look for issues labeled `good first issue`
2. Start with documentation improvements
3. Fix typos or improve code comments
4. Add unit tests for existing functionality

---

## Code of Conduct

### Our Standards

- **Be Respectful**: Treat all contributors with respect and kindness
- **Be Collaborative**: Work together to improve the project
- **Be Constructive**: Provide helpful feedback and suggestions
- **Be Patient**: Remember that everyone has different experience levels

### Unacceptable Behavior

- Harassment or discrimination of any kind
- Inflammatory or offensive language
- Personal attacks or trolling
- Spam or off-topic discussions

### Enforcement

Violations of the code of conduct should be reported to the project maintainers. All reports will be reviewed and investigated promptly.

---

## How to Contribute

### Types of Contributions

#### 🐛 Bug Reports
- Use the bug report template
- Include reproduction steps
- Provide device/OS information
- Attach screenshots if relevant

#### ✨ Feature Requests
- Use the feature request template
- Explain the problem you're solving
- Describe your proposed solution
- Consider backwards compatibility

#### 📝 Documentation
- Fix typos and grammar
- Improve clarity and examples
- Add missing documentation
- Update outdated information

#### 🔧 Code Contributions
- Bug fixes
- Performance improvements
- New features
- Code refactoring

#### 🧪 Testing
- Add missing unit tests
- Improve test coverage
- Performance testing
- Device compatibility testing

### What We're Looking For

#### High Priority
- Performance optimizations
- Bug fixes affecting multiple users
- Accessibility improvements
- Test coverage improvements

#### Medium Priority
- New physics effects
- UI enhancements
- Additional platforms (visionOS, tvOS)
- Developer tools and debugging features

#### Low Priority
- Major architectural changes
- Breaking API changes
- Experimental features

---

## Development Setup

### Environment Configuration

#### Xcode Settings
```bash
# Configure Xcode command line tools
sudo xcode-select --install

# Set up code formatting (optional)
# Install SwiftFormat if available
```

#### Project Configuration
```bash
# Set up git hooks (optional)
cp scripts/pre-commit .git/hooks/
chmod +x .git/hooks/pre-commit
```

### Building the Project

#### All Targets
```bash
# Clean build all targets
xcodebuild clean -project Lizard.xcodeproj
xcodebuild -project Lizard.xcodeproj -scheme Lizard
```

#### iOS Only
```bash
xcodebuild -project Lizard.xcodeproj -scheme Lizard -destination 'platform=iOS Simulator,name=iPhone 15'
```

#### watchOS
```bash
xcodebuild -project Lizard.xcodeproj -scheme LizardWatch -destination 'platform=watchOS Simulator,name=Apple Watch Series 9 (45mm)'
```

### Running Tests

```bash
# All tests
xcodebuild test -project Lizard.xcodeproj -scheme Lizard

# iOS tests only
xcodebuild test -project Lizard.xcodeproj -scheme Lizard -destination 'platform=iOS Simulator,name=iPhone 15'

# watchOS tests only
xcodebuild test -project Lizard.xcodeproj -scheme LizardWatch -destination 'platform=watchOS Simulator,name=Apple Watch Series 9 (45mm)'
```

---

## Coding Standards

### Swift Style Guide

#### Naming Conventions
```swift
// Use descriptive names
func spawnLizardWithRandomVelocity(at position: CGPoint) { ... }

// Constants in PascalCase
struct Config {
    static let MaxPhysicsLizards = 300
    static let DefaultAnimationDuration: TimeInterval = 0.3
}

// Variables and functions in camelCase
var currentFPS: Double = 60.0
func updateGravityVector(from data: CMAccelerometerData) { ... }

// Private properties with underscore (optional)
private var _audioPlayers: [AVAudioPlayer] = []
```

#### Code Organization
```swift
// MARK: sections for organization
class LizardScene: SKScene {
    
    // MARK: - Properties
    private let physicsLayer = SKNode()
    private var lizardTexture: SKTexture?
    
    // MARK: - Lifecycle
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupScene()
    }
    
    // MARK: - Public API
    func spawnLizard(at position: CGPoint) {
        // Implementation
    }
    
    // MARK: - Private Methods
    private func setupScene() {
        // Implementation
    }
}
```

#### Documentation
```swift
/// Spawns a new lizard sprite with physics properties
/// - Parameter position: Screen coordinates for spawn location
/// - Returns: The created lizard node, or nil if spawn failed
@discardableResult
func spawnLizard(at position: CGPoint) -> SKNode? {
    // Implementation
}
```

### SwiftUI Style

#### View Organization
```swift
struct ContentView: View {
    // MARK: - State
    @StateObject private var scene = LizardScene()
    @State private var totalLizards = 0
    
    // MARK: - Body
    var body: some View {
        ZStack {
            backgroundView
            gameView
            overlayView
        }
    }
    
    // MARK: - View Components
    private var backgroundView: some View {
        DynamicBackgroundView()
            .ignoresSafeArea()
    }
    
    private var gameView: some View {
        SpriteView(scene: scene)
            .onAppear(perform: setupScene)
    }
    
    // MARK: - Actions
    private func setupScene() {
        // Implementation
    }
}
```

#### Performance Considerations
```swift
// Use @ViewBuilder for conditional views
@ViewBuilder
private func gameControls() -> some View {
    if gameState.isPlaying {
        PlayingControls()
    } else {
        PausedControls()
    }
}

// Avoid expensive operations in body
struct OptimizedView: View {
    let expensiveValue: String
    
    init(data: GameData) {
        // Calculate expensive values in init, not in body
        self.expensiveValue = calculateExpensiveValue(from: data)
    }
}
```

### Performance Guidelines

#### Memory Management
```swift
// Use weak references for delegates
weak var delegate: LizardSceneDelegate?

// Clean up resources in deinit
deinit {
    motionManager.stopAccelerometerUpdates()
    NotificationCenter.default.removeObserver(self)
}

// Use object pooling for frequently created objects
private var lizardPool: [SKSpriteNode] = []

func createLizard() -> SKSpriteNode {
    return lizardPool.popLast() ?? SKSpriteNode(imageNamed: "lizard")
}
```

#### Frame Rate Optimization
```swift
// Monitor performance and adjust quality
func update(_ currentTime: TimeInterval) {
    updateFrameRate(currentTime)
    
    if currentFPS < 45 {
        // Reduce quality
        reduceVisualEffects()
    }
}

// Use efficient collision detection
func setupPhysics() {
    // Use appropriate category bit masks
    lizardNode.physicsBody?.categoryBitMask = PhysicsCategory.lizard
    lizardNode.physicsBody?.contactTestBitMask = PhysicsCategory.boundary
}
```

---

## Testing Guidelines

### Unit Test Standards

#### Test Structure
```swift
class LizardSceneTests: XCTestCase {
    var scene: LizardScene!
    
    override func setUp() {
        super.setUp()
        scene = LizardScene()
    }
    
    override func tearDown() {
        scene = nil
        super.tearDown()
    }
    
    func testSpawnLizardCreatesNode() {
        // Arrange
        let position = CGPoint(x: 100, y: 100)
        let initialCount = scene.children.count
        
        // Act
        scene.spawnLizard(at: position)
        
        // Assert
        XCTAssertEqual(scene.children.count, initialCount + 1)
        XCTAssertNotNil(scene.children.last?.physicsBody)
    }
}
```

#### Test Coverage Goals
- **Minimum**: 70% code coverage for new features
- **Target**: 85% code coverage for critical components
- **Focus Areas**: Public APIs, error handling, edge cases

#### Performance Tests
```swift
func testSpawnPerformance() {
    measure {
        for _ in 0..<100 {
            scene.spawnLizard(at: CGPoint.zero)
        }
    }
}

func testMemoryUsage() {
    let initialMemory = scene.children.count
    
    // Spawn many lizards
    for _ in 0..<1000 {
        scene.spawnLizard(at: CGPoint.zero)
    }
    
    // Trigger cleanup
    scene.clearAllLizards()
    
    // Verify cleanup
    XCTAssertEqual(scene.children.count, initialMemory)
}
```

### Integration Testing

#### Device Testing Checklist
- [ ] iPhone SE (small screen)
- [ ] iPhone 15 (current generation)
- [ ] iPhone 15 Pro Max (large screen)
- [ ] iPad (if supported)
- [ ] Apple Watch Series 7+ (watchOS)

#### Platform Testing
- [ ] iOS 18.0 (minimum version)
- [ ] iOS 18.1+ (latest available)
- [ ] watchOS 9.0 (minimum version)
- [ ] watchOS 10.0+ (latest available)

---

## Pull Request Process

### Before Submitting

#### Checklist
- [ ] Code follows project style guidelines
- [ ] All tests pass
- [ ] New features have tests
- [ ] Documentation is updated
- [ ] Performance impact is acceptable
- [ ] No new compiler warnings

#### Testing
```bash
# Run full test suite
xcodebuild test -project Lizard.xcodeproj -scheme Lizard

# Check for warnings
xcodebuild -project Lizard.xcodeproj -scheme Lizard | grep warning

# Test on multiple simulators
xcodebuild test -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)'
xcodebuild test -destination 'platform=iOS Simulator,name=iPhone 15 Pro Max'
```

### Pull Request Template

```markdown
## Description
Brief description of changes and why they're needed.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed
- [ ] Performance impact assessed

## Checklist
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes

## Screenshots (if applicable)
Add screenshots to help explain your changes.

## Additional Notes
Any additional information that would be helpful for reviewers.
```

### Review Process

#### Reviewer Guidelines
- **Be Constructive**: Focus on the code, not the person
- **Be Specific**: Provide clear, actionable feedback
- **Be Timely**: Review PRs within 48 hours when possible
- **Be Thorough**: Check functionality, style, and tests

#### Common Review Points
- Code style and consistency
- Performance implications
- Test coverage and quality
- Documentation completeness
- Backwards compatibility
- Security considerations

---

## Issue Guidelines

### Bug Reports

#### Required Information
```markdown
**Device Information:**
- Device: iPhone 15 Pro
- iOS Version: 18.1
- App Version: 1.1.0

**Description:**
Clear description of the bug.

**Steps to Reproduce:**
1. Open the app
2. Tap spawn button
3. Tilt device left
4. Observe incorrect behavior

**Expected Behavior:**
What should happen.

**Actual Behavior:**
What actually happens.

**Additional Context:**
Any other context about the problem.
```

#### Bug Severity Levels
- **Critical**: App crashes, data loss, security vulnerabilities
- **High**: Major feature broken, significant performance issues
- **Medium**: Minor feature issues, UI glitches
- **Low**: Cosmetic issues, minor inconveniences

### Feature Requests

#### Template
```markdown
**Problem Statement:**
What problem does this feature solve?

**Proposed Solution:**
Describe your proposed solution.

**Alternatives Considered:**
What other solutions did you consider?

**Additional Context:**
Any other context or screenshots about the feature request.

**Implementation Notes:**
Technical considerations (if any).
```

#### Evaluation Criteria
- **User Impact**: How many users would benefit?
- **Implementation Complexity**: How difficult to implement?
- **Maintenance Burden**: Ongoing maintenance requirements
- **Platform Consistency**: Fits with existing design patterns

---

## Documentation Guidelines

### Documentation Types

#### Code Documentation
```swift
/// Calculates physics gravity vector from device motion data
/// 
/// This function converts Core Motion accelerometer data into a gravity vector
/// suitable for SpriteKit physics simulation. The conversion accounts for
/// device orientation and applies appropriate scaling factors.
///
/// - Parameter data: Accelerometer data from Core Motion
/// - Returns: Gravity vector in SpriteKit coordinate system
/// - Note: Returns zero vector if data is invalid
/// - Important: Must be called on main thread
func gravityVector(from data: CMAccelerometerData) -> CGVector {
    // Implementation
}
```

#### README Documentation
- Clear project description
- Installation instructions
- Basic usage examples
- Platform requirements
- Links to detailed documentation

#### API Documentation
- Complete parameter descriptions
- Return value explanations
- Usage examples
- Error conditions
- Platform availability

### Documentation Standards

#### Writing Style
- **Clear and Concise**: Use simple, direct language
- **User-Focused**: Write from the user's perspective
- **Complete**: Include all necessary information
- **Current**: Keep documentation up-to-date with code changes

#### Formatting
- Use consistent heading styles
- Include code examples in fenced blocks
- Add table of contents for long documents
- Use lists for step-by-step instructions

#### Images and Diagrams
- Include screenshots for UI changes
- Use diagrams for complex architecture
- Optimize images for file size
- Provide alt text for accessibility

---

## Release Process

### Version Numbering

We follow [Semantic Versioning](https://semver.org/):
- **Major (X.0.0)**: Breaking changes
- **Minor (X.Y.0)**: New features, backwards compatible
- **Patch (X.Y.Z)**: Bug fixes, backwards compatible

### Release Checklist

#### Pre-Release
- [ ] All tests pass
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version numbers incremented
- [ ] Performance regression testing
- [ ] Device compatibility testing

#### Release
- [ ] Create release branch
- [ ] Final testing on release branch
- [ ] Tag release in Git
- [ ] Build and archive for distribution
- [ ] Submit to App Store Connect
- [ ] Update GitHub release page

#### Post-Release
- [ ] Monitor crash reports
- [ ] Review user feedback
- [ ] Plan next release cycle
- [ ] Update project roadmap

### Beta Testing

#### TestFlight Process
1. **Build for Testing**: Archive and upload to App Store Connect
2. **Internal Testing**: Test with development team
3. **External Testing**: Invite beta testers
4. **Feedback Collection**: Use screenshot feedback system
5. **Issue Triage**: Prioritize and fix critical issues

#### Beta Feedback
- **Response Time**: Acknowledge feedback within 24 hours
- **Bug Triage**: Categorize and prioritize issues
- **Feature Requests**: Evaluate and add to roadmap
- **Communication**: Keep testers informed of progress

---

## Community

### Communication Channels

#### GitHub
- **Issues**: Bug reports and feature requests
- **Discussions**: General questions and ideas
- **Pull Requests**: Code contributions
- **Releases**: Version announcements

#### Best Practices
- **Search First**: Check existing issues before creating new ones
- **Be Descriptive**: Provide detailed information
- **Stay On Topic**: Keep discussions focused
- **Be Patient**: Allow time for responses

### Recognition

#### Contributors
All contributors are recognized in:
- CHANGELOG.md contributor acknowledgments
- GitHub contributors page
- Release notes

#### Types of Recognition
- **Code Contributors**: Direct code contributions
- **Documentation**: Documentation improvements
- **Testing**: Bug reports and testing
- **Community**: Helping other users

---

## Getting Help

### Resources
- **[Developer Guide](DEVELOPER_GUIDE.md)**: Technical development information
- **[API Reference](API_REFERENCE.md)**: Complete API documentation
- **[Troubleshooting](TROUBLESHOOTING.md)**: Common issues and solutions
- **[Building Guide](BUILDING.md)**: Build and setup instructions

### Support Channels
- **GitHub Issues**: Technical problems and bugs
- **GitHub Discussions**: Questions and general discussion
- **Apple Documentation**: iOS/watchOS development resources
- **Swift Forums**: Swift language questions

### Mentorship
- New contributors are welcome to ask questions
- Maintainers will provide guidance and feedback
- Start with small contributions to learn the process
- Join discussions to understand project direction

---

*Thank you for contributing to Lizard! Your contributions help make the app better for everyone. 🦎✨*

---

*This contributing guide is updated regularly. Please check back for the latest guidelines and processes. Last updated: Version 1.1.0*