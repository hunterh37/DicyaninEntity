//
//  DicyaninEntity+Extensions.swift
//  DicyaninEntity
//
//  Created by Dicyanin Labs
//  Copyright © 2025 Dicyanin Labs. All rights reserved.
//

import RealityKit
import simd
import UIKit

public extension DicyaninEntity {
    
    /// Creates a copy of the entity with the same model and transform
    func clone() -> DicyaninEntity {
        let clonedEntity = DicyaninEntity(modelComponent: self.modelComponent)
        clonedEntity.transform = self.transform
        return clonedEntity
    }
    
    /// Rotates the entity around a specific axis by the given angle
    func rotate(by angle: Float, around axis: SIMD3<Float>) {
        let rotation = simd_quatf(angle: angle, axis: axis)
        self.transform.rotation *= rotation
    }
    
    /// Scales the entity uniformly
    func scale(by factor: Float) {
        self.transform.scale *= factor
    }
    
    /// Moves the entity relative to its current position
    func move(by offset: SIMD3<Float>) {
        self.transform.translation += offset
    }
    
    /// Sets the entity's position while maintaining its rotation and scale
    func setPosition(_ position: SIMD3<Float>) {
        self.transform.translation = position
    }
    
    /// Creates a new entity with the same model but at a different position
    func atPosition(_ position: SIMD3<Float>) -> DicyaninEntity {
        let entity = self.clone()
        entity.setPosition(position)
        return entity
    }
    
    /// Applies a material to all parts of the entity
    func applyMaterial(_ material: Material) {
        self.updateModel(mesh: self.modelComponent.mesh, materials: [material])
    }
    
    /// Sets the color of the entity's material
    func setMaterialColor(_ color: UIColor, isMetallic: Bool = false) {
        let material = SimpleMaterial(color: color, isMetallic: isMetallic)
        self.applyMaterial(material)
    }
    
    /// Returns the direction vector pointing to another entity
    func direction(to entity: Entity) -> SIMD3<Float> {
        return normalize(entity.transform.translation - self.transform.translation)
    }
    
    /// Adds collision and physics to the entity based on its mesh shape
    func addPhysics(mass: Float = 1.0, isDynamic: Bool = true, isAffectedByGravity: Bool = true) {
        // Create collision shape from the mesh
        let collisionShape = ShapeResource.generateConvex(from: self.modelComponent.mesh)
        
        // Create physics body
        var physicsBody = PhysicsBodyComponent()
        physicsBody.massProperties.mass = mass
        physicsBody.mode = isDynamic ? .dynamic : .static
        physicsBody.isAffectedByGravity = isAffectedByGravity
        
        // Add components
        self.components[CollisionComponent.self] = CollisionComponent(shapes: [collisionShape])
        self.components[PhysicsBodyComponent.self] = physicsBody
    }
    
    /// Removes physics and collision from the entity
    func removePhysics() {
        self.components[CollisionComponent.self] = nil
        self.components[PhysicsBodyComponent.self] = nil
    }
} 
