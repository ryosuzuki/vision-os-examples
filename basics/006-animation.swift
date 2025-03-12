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
                    materials: [SimpleMaterial(color: .red, isMetallic: false)]
                )
                box.position = SIMD3(x: 0, y: 1, z: -5)
                content.add(box)

                let animation = try! AnimationResource.generate(with: FromToByAnimation<Transform>(
                    from: .init(scale: .init(repeating: 1), translation: box.position),
                    to: .init(scale: .init(repeating: 2), translation: box.position + .init(x: 0, y: 0.5, z: 0)),
                    duration: 5,
                    bindTarget: .transform
                ))
                box.playAnimation(animation)
            }
        }
    }
}