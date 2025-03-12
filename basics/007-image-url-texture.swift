import SwiftUI
import RealityKit

@main
struct SampleApp: App {
    var body: some SwiftUI.Scene {
        ImmersiveSpace {
            RealityView { content in
                let url = URL(string: "https://ryosuzuki.org/static/images/profile.png")!
                if let texture = await loadTextureAsync(url: url) {
                    var material = SimpleMaterial()
                    material.color = .init(texture: .init(texture))
                    let plane = ModelEntity(
                        mesh: .generatePlane(width: 0.5, depth: 0.5),
                        materials: [material]
                    )
                    plane.position = SIMD3(x: 0, y: 1, z: -2)
                    content.add(plane)
                }

                func loadTextureAsync(url: URL) async -> TextureResource? {
                    do {
                        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
                        let data = try Data(contentsOf: url)
                        try! data.write(to: fileURL)
                        let texture = try await TextureResource(contentsOf: fileURL)
                        return texture
                    } catch {
                        print("error")
                        return nil
                    }
                }
            }
        }
    }
}