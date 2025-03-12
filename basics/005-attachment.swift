import SwiftUI
import RealityKit

@main
struct SampleApp: App {
    var body: some SwiftUI.Scene {
        ImmersiveSpace {
            var box = ModelEntity()

            RealityView { content, attachments in
                box = ModelEntity(
                    mesh: .generateBox(size: 0.5),
                    materials: [SimpleMaterial(color: .red, isMetallic: false)]
                )
                box.position = SIMD3(x: 0, y: 1, z: -5)
                content.add(box)

                let plane = ModelEntity(
                    mesh: .generatePlane(width: 5, depth: 5),
                    materials: [SimpleMaterial(color: .blue, isMetallic: false)]
                )
                plane.position = SIMD3(x: 0, y: 0, z: -5)
                content.add(plane)

                if let attachement = attachments.entity(for: "box_label") {
                    attachement.position = [0, -0.5, 0]
                    box.addChild(attachement)
                }
                if let attachement = attachments.entity(for: "plane_label") {
                    attachement.orientation = simd_quatf(angle: -.pi/2, axis: [1, 0, 0])
                    attachement.position = [0, 0, 2.8]
                    plane.addChild(attachement)
                }
            } attachments: {
                Attachment(id: "box_label") {
                    Text("Box Hello World")
                        .font(.system(size: 150))
                }
                Attachment(id: "plane_label") {
                    Text("Plane Hello World")
                        .font(.system(size: 150))
                }

            }
        }
    }
}