import RealityKit
import UIKit

/// Construye la escena de RA: el Sol y los planetas como esferas generadas en código.
/// Los tamaños y las distancias NO están a escala real; se ajustan para que se vean bien.
enum SistemaSolarFactory {
    static func crearEscena(planetas: [Planeta]) -> AnchorEntity {
        // Se ancla a una superficie horizontal detectada (mesa o piso).
        let ancla = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: [0.2, 0.2]))

        let separacion: Float = 0.11   // metros entre cuerpos
        let altura: Float = 0.15       // metros sobre la superficie
        let cuerpos = planetas.count + 1
        let inicioX = -Float(cuerpos - 1) * separacion / 2

        // Sol
        let sol = ModelEntity(
            mesh: .generateSphere(radius: 0.06),
            materials: [UnlitMaterial(color: .systemYellow)]
        )
        sol.name = "sol"
        sol.position = [inicioX, altura, 0]
        sol.generateCollisionShapes(recursive: false)
        sol.components.set(InputTargetComponent())
        ancla.addChild(sol)

        // Planetas (el nombre de cada entidad es el id del planeta; se usa al tocarlo)
        for (indice, planeta) in planetas.enumerated() {
            let esfera = ModelEntity(
                mesh: .generateSphere(radius: Float(planeta.radioVisualM)),
                materials: [SimpleMaterial(color: UIColor(hex: planeta.colorHex), isMetallic: false)]
            )
            esfera.name = planeta.id
            esfera.position = [inicioX + separacion * Float(indice + 1), altura, 0]
            esfera.generateCollisionShapes(recursive: false)
            esfera.components.set(InputTargetComponent())
            ancla.addChild(esfera)
        }

        return ancla
    }
}
