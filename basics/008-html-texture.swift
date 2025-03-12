import SwiftUI
import WebKit
import RealityKit

@main
struct SampleApp: App {
    var body: some SwiftUI.Scene {
        ImmersiveSpace {
            RealityView { content in
                let texture = await loadHTMLTextureAsync()
                var material = SimpleMaterial()
                material.color = .init(texture: .init(texture!))
                let plane = ModelEntity(
                    mesh: .generatePlane(width: 0.5, depth: 0.5),
                    materials: [material]
                )
                plane.position = SIMD3(x: 0, y: 1, z: -0.5)
                content.add(plane)

                func loadHTMLTextureAsync() async -> TextureResource? {
                    do {
                        let html = "<html><body><h1>Hello world</h1><img src='https://ryosuzuki.org/static/images/profile.png' width='100' /><p>hello</p><iframe width='560' height='315' src='https://www.youtube.com/embed/Vb0dG-2huJE' frameborder='0' allowfullscreen></iframe></body></html>"
                        let webView = await WKWebView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
                        await webView.loadHTMLString(html, baseURL: nil)
                        try? await Task.sleep(nanoseconds: 2_000_000_000) // dealay 2 seconds
                        let image = try await webView.takeSnapshotAsync(configuration: nil)
                        let texture = try await TextureResource.generate(from: image.cgImage!, options: .init(semantic: nil))
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

extension WKWebView {
    func takeSnapshotAsync(configuration: WKSnapshotConfiguration?) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            takeSnapshot(with: configuration) { image, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let image = image {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(throwing: NSError(domain: "SnapshotError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown snapshot error"]))
                }
            }
        }
    }
}