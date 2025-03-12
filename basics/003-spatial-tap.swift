import SwiftUI
import RealityKit

@main
struct SampleApp: App {
    var body: some SwiftUI.Scene {
        ImmersiveSpace {
            var box = ModelEntity()

            RealityView { content in
                box = ModelEntity(
                    mesh: .generateBox(size: 0.5),
                    materials: [SimpleMaterial(color: .red, isMetallic: false)],
                    collisionShape: .generateBox(size: SIMD3<Float>(repeating: 0.5)),
                    mass: 0.1
                )
                box.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                box.components.set(PhysicsBodyComponent(shapes: box.collision!.shapes, mass: 0.1, mode: .dynamic))
                box.position = SIMD3(x: 0, y: 1, z: -5)
                content.add(box)

                let plane = ModelEntity(
                    mesh: .generatePlane(width: 5, depth: 5),
                    materials: [SimpleMaterial(color: .blue, isMetallic: false)],
                    collisionShape: .generateBox(width: 5, height: 0.1, depth: 5),
                    mass: 1
                )
                plane.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                plane.components.set(PhysicsBodyComponent(shapes: plane.collision!.shapes, mass: 1, mode: .static))
                plane.position = SIMD3(x: 0, y: 0, z: -5)
                content.add(plane)
            }
            .gesture(
                SpatialTapGesture()
                    .targetedToAnyEntity()
                    .onEnded { value in
                        box.position = SIMD3(x: 0, y: 1, z: -5)
                    }
            )
        }
    }
}