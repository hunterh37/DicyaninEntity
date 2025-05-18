//
//  DicyaninEntity+Configuration.swift
//  DicyaninEntity
//
//  Created by Dicyanin Labs
//  Copyright © 2025 Dicyanin Labs. All rights reserved.
//

import RealityKit
import simd
import ARKit

// MARK: - Component Types
public struct ModelAnimation {
    public enum AnimationType {
        case bounce(height: Float, duration: TimeInterval)
        case spin(speed: Float, axis: SIMD3<Float>)
    }
    public let type: AnimationType
    
    public init(type: AnimationType) {
        self.type = type
    }
}

public struct ModelPhysics {
    public let mass: Float
    public let isDynamic: Bool
    
    public init(mass: Float, isDynamic: Bool) {
        self.mass = mass
        self.isDynamic = isDynamic
    }
}

public struct ModelCollision {
    public enum Shape {
        case sphere(radius: Float)
        case box(size: SIMD3<Float>)
    }
    public let shape: Shape
    public let isStatic: Bool
    
    public init(shape: Shape, isStatic: Bool) {
        self.shape = shape
        self.isStatic = isStatic
    }
}

public struct ModelInteraction {
    public enum InteractionType {
        case tap
        case drag
    }
    public let type: InteractionType
    public let action: String
    
    public init(type: InteractionType, action: String) {
        self.type = type
        self.action = action
    }
}

public enum InteractionType {
    case tap
    case drag
    case physics
    case none
    
    public var requiresPhysics: Bool {
        switch self {
        case .physics, .drag: return true
        default: return false
        }
    }
}

public struct ModelAnchoring {
    public let target: AnchoringComponent.Target
    public let trackingMode: AnchoringComponent.TrackingMode
    
    public init(target: AnchoringComponent.Target, trackingMode: AnchoringComponent.TrackingMode) {
        self.target = target
        self.trackingMode = trackingMode
    }
}

// MARK: - Entity Configuration
public struct DicyaninEntityConfiguration {
    public let name: String
    public let position: SIMD3<Float>
    public let rotation: simd_quatf
    public let scale: SIMD3<Float>
    public let playAnimation: Bool
    public let animation: ModelAnimation?
    public let physics: ModelPhysics?
    public let collision: ModelCollision?
    public let interaction: ModelInteraction?
    public let interactionType: InteractionType
    public var anchoring: ModelAnchoring?
    public var particleComponent: ParticleEmitterComponent?
    
    public init(
        name: String,
        position: SIMD3<Float> = .zero,
        rotation: simd_quatf = simd_quatf(angle: 0, axis: SIMD3<Float>(x: 0, y: 1, z: 0)),
        scale: SIMD3<Float> = SIMD3<Float>(repeating: 1),
        playAnimation: Bool = false,
        animation: ModelAnimation? = nil,
        physics: ModelPhysics? = nil,
        collision: ModelCollision? = nil,
        interaction: ModelInteraction? = nil,
        interactionType: InteractionType = .none,
        anchoring: ModelAnchoring? = nil,
        particleComponent: ParticleEmitterComponent? = nil,
    ) {
        self.name = name
        self.position = position
        self.rotation = rotation
        self.scale = scale
        self.playAnimation = playAnimation
        self.animation = animation
        self.physics = physics
        self.collision = collision
        self.interaction = interaction
        self.interactionType = interactionType
        self.anchoring = anchoring
        self.particleComponent = particleComponent
    }
}

// MARK: - DicyaninEntity Extension
public extension DicyaninEntity {
    
    /// Configure the entity with the given configuration
    @MainActor
    func configure(with config: DicyaninEntityConfiguration) async throws {
        // Apply base transformations
        self.transform.translation = config.position
        self.transform.rotation = config.rotation
        self.transform.scale = config.scale
        
        // Add anchoring if present
        if let anchoring = config.anchoring {
            self.components.set(AnchoringComponent(anchoring.target, trackingMode: anchoring.trackingMode))
        }
        
        // Add collision if present
        if let collision = config.collision {
            let shape: ShapeResource
            switch collision.shape {
            case .sphere(let radius):
                shape = .generateSphere(radius: radius)
            case .box(let size):
                shape = .generateBox(size: size)
            }
            self.components[CollisionComponent.self] = CollisionComponent(
                shapes: [shape],
                mode: collision.isStatic ? .trigger : .default
            )
            
            // Add physics if present
            if let physics = config.physics {
                self.components[PhysicsBodyComponent.self] = PhysicsBodyComponent(
                    shapes: [shape],
                    mass: physics.mass,
                    mode: physics.isDynamic ? .dynamic : .kinematic
                )
            }
        }
        
        // Add interaction if present
        if let _ = config.interaction {
            self.components[InputTargetComponent.self] = InputTargetComponent()
        }
        
        // Set up physics if needed
        if config.interactionType.requiresPhysics {
            if self.components[PhysicsBodyComponent.self] == nil {
                let shape = ShapeResource.generateBox(size: SIMD3<Float>(repeating: 0.5))
                self.components[PhysicsBodyComponent.self] = PhysicsBodyComponent(
                    shapes: [shape],
                    mass: 1.0,
                    mode: .dynamic
                )
            }
        }
        
        if let particleComponent = config.particleComponent {
            self.components.set(particleComponent)
        }
    }
    
    /// Create a new DicyaninEntity from a configuration
    @MainActor
    static func create(from config: DicyaninEntityConfiguration) async throws -> DicyaninEntity {
        // Load the USDZ model
        guard let modelEntity = try? await ModelEntity(named: config.name) else {
            throw NSError(domain: "DicyaninEntity", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to load model: \(config.name)"])
        }
        
        // Create entity with the model entity
        let entity = DicyaninEntity()
        entity.addChild(modelEntity)
        try await entity.configure(with: config)
        return entity
    }
}
