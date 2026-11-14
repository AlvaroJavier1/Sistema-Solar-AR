import Foundation

/// Modelo de datos de un planeta (MVVM: Modelo).
struct Planeta: Identifiable, Hashable, Codable {
    let id: String
    let nombre: String
    let orden: Int
    let tipo: String
    let descripcion: String
    let curiosidad: String
    let diametroKm: Double
    let distanciaSolMillonesKm: Double
    let periodoOrbitalDias: Double
    let lunas: String
    let temperatura: String
    let colorHex: String
    /// Radio de la esfera en la escena de RA, en metros (no está a escala real).
    let radioVisualM: Double
}

extension Planeta {
    /// Crea un planeta a partir de un documento de Firestore.
    /// Se lee el diccionario a mano para no depender de módulos extra del SDK.
    init?(id: String, data: [String: Any]) {
        func numero(_ clave: String) -> Double? {
            (data[clave] as? NSNumber)?.doubleValue
        }

        guard
            let nombre = data["nombre"] as? String,
            let tipo = data["tipo"] as? String,
            let descripcion = data["descripcion"] as? String,
            let curiosidad = data["curiosidad"] as? String,
            let lunas = data["lunas"] as? String,
            let temperatura = data["temperatura"] as? String,
            let colorHex = data["colorHex"] as? String,
            let orden = numero("orden"),
            let diametroKm = numero("diametroKm"),
            let distancia = numero("distanciaSolMillonesKm"),
            let periodo = numero("periodoOrbitalDias"),
            let radioVisual = numero("radioVisualM")
        else { return nil }

        self.init(
            id: id,
            nombre: nombre,
            orden: Int(orden),
            tipo: tipo,
            descripcion: descripcion,
            curiosidad: curiosidad,
            diametroKm: diametroKm,
            distanciaSolMillonesKm: distancia,
            periodoOrbitalDias: periodo,
            lunas: lunas,
            temperatura: temperatura,
            colorHex: colorHex,
            radioVisualM: radioVisual
        )
    }
}
