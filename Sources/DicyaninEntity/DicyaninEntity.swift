import RealityKit
import simd

public class DicyaninEntity: Entity {
    // MARK: - Properties
    
    /// The model component that defines the visual appearance
    public var modelComponent: ModelComponent
    
    // MARK: - Initialization
    
    public init(modelComponent: ModelComponent) {
        self.modelComponent = modelComponent
        super.init()
        self.components[ModelComponent.self] = modelComponent
    }
    
    public required init() {
        self.modelComponent = ModelComponent()
        super.init()
        self.components[ModelComponent.self] = modelComponent
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
