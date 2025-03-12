import SwiftUI
import RealityKit

@main
struct SampleApp: App {
    var body: some SwiftUI.Scene {
        ImmersiveSpace {
            RealityView { content in
                let box = ModelEntity(mesh: .generateBox(size: 0.5))
                box.position = SIMD3(x: 0, y: 0.5, z: -2)
                content.add(box)
            }
        }
    }
}