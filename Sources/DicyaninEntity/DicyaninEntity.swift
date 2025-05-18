//
//  DicyaninEntity.swift
//  DicyaninEntity
//
//  Created by Dicyanin Labs
//  Copyright © 2025 Dicyanin Labs. All rights reserved.
//

import RealityKit
import simd

public class DicyaninEntity: Entity {
    // MARK: - Properties
    
    /// The model component that defines the visual appearance
    public var modelComponent: ModelComponent
    
    // MARK: - Initialization
    
    /// Initialize with a custom model component
    public init(modelComponent: ModelComponent) {
        self.modelComponent = modelComponent
        super.init()
        self.components[ModelComponent.self] = modelComponent
    }
    
    /// Initialize with default settings (white cube)
    public required init() {
        self.modelComponent = ModelComponent(mesh: .generateBox(size: 0.0001), materials: [SimpleMaterial(color: .clear, isMetallic: false)])
        super.init()
    }
    
    /// Initialize with a custom mesh and material
    public convenience init(mesh: MeshResource, material: Material) {
        let modelComponent = ModelComponent(mesh: mesh, materials: [material])
        self.init(modelComponent: modelComponent)
    }
    
    /// Initialize with a custom mesh and array of materials
    public convenience init(mesh: MeshResource, materials: [Material]) {
        let modelComponent = ModelComponent(mesh: mesh, materials: materials)
        self.init(modelComponent: modelComponent)
    }
    
    /// Initialize with a custom mesh, material, and transform
    public convenience init(mesh: MeshResource, material: Material, transform: Transform) {
        let modelComponent = ModelComponent(mesh: mesh, materials: [material])
        self.init(modelComponent: modelComponent)
        self.transform = transform
    }
    
    /// Initialize with a custom mesh, materials, and transform
    public convenience init(mesh: MeshResource, materials: [Material], transform: Transform) {
        let modelComponent = ModelComponent(mesh: mesh, materials: materials)
        self.init(modelComponent: modelComponent)
        self.transform = transform
    }
    
    // MARK: - Public Methods
    
    /// Updates the model component with a new mesh and materials
    public func updateModel(mesh: MeshResource, materials: [Material]) {
        modelComponent.mesh = mesh
        modelComponent.materials = materials
        self.components[ModelComponent.self] = modelComponent
    }
    
    /// Sets the transform of the entity
    public func setTransform(translation: SIMD3<Float>, rotation: simd_quatf, scale: SIMD3<Float>) {
        self.transform.translation = translation
        self.transform.rotation = rotation
        self.transform.scale = scale
    }
} 
