# DicyaninEntity

A custom RealityKit entity package for visionOS applications that provides a sophisticated and extensible entity class for 3D content creation.

## Requirements

- iOS 17.0+ / visionOS 1.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/hunterh37/DicyaninEntity.git", from: "1.0.0")
]
```

Or add it directly in Xcode:
1. Go to File > Add Packages...
2. Enter the repository URL: `https://github.com/hunterh37/DicyaninEntity.git`
3. Click Add Package

## Usage

### Basic Implementation

```swift
import RealityKit
import DicyaninEntity

// Create a new entity with default settings (white cube)
let entity = DicyaninEntity()

// Or create with custom model component
let customMesh = MeshResource.generateSphere(radius: 0.5)
let customMaterial = SimpleMaterial(color: .blue, isMetallic: true)
let modelComponent = ModelComponent(mesh: customMesh, materials: [customMaterial])
let customEntity = DicyaninEntity(modelComponent: modelComponent)

// Update the model later
entity.updateModel(mesh: customMesh, materials: [customMaterial])

// Set transform
entity.setTransform(
    translation: SIMD3<Float>(0, 1, -2),
    rotation: simd_quatf(angle: .pi/4, axis: SIMD3<Float>(0, 1, 0)),
    scale: SIMD3<Float>(1, 1, 1)
)
```

## Features

- Custom RealityKit entity implementation
- Easy model component management
- Transform control with translation, rotation, and scale
- visionOS optimized

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

[Your Name]

## Acknowledgments

- Built with RealityKit
- Designed for visionOS 