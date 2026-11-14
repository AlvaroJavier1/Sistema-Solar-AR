import Foundation
import FirebaseFirestore

/// Fuente de datos de los planetas. Permite cambiar Firestore por una copia local.
protocol PlanetasRepository {
    func obtenerPlanetas() async throws -> [Planeta]
    func registrarConsulta(planetaId: String) async
}

enum RepositorioError: Error {
    case sinDatos
    case archivoLocalNoEncontrado
}

/// Lee los planetas de Cloud Firestore y registra las consultas.
struct FirestorePlanetasRepository: PlanetasRepository {
    func obtenerPlanetas() async throws -> [Planeta] {
        let snapshot = try await Firestore.firestore()
            .collection("planetas")
            .order(by: "orden")
            .getDocuments()
        return snapshot.documents.compactMap { documento in
            Planeta(id: documento.documentID, data: documento.data())
        }
    }

    func registrarConsulta(planetaId: String) async {
        let datos: [String: Any] = [
            "planetaId": planetaId,
            "fecha": FieldValue.serverTimestamp()
        ]
        // Si falla (por ejemplo, sin conexión), la app sigue funcionando.
        _ = try? await Firestore.firestore().collection("consultas").addDocument(data: datos)
    }
}

/// Copia local (planetas.json dentro de la app) para cuando no hay conexión.
struct LocalPlanetasRepository: PlanetasRepository {
    func obtenerPlanetas() async throws -> [Planeta] {
        guard let url = Bundle.main.url(forResource: "planetas", withExtension: "json") else {
            throw RepositorioError.archivoLocalNoEncontrado
        }
        let datos = try Data(contentsOf: url)
        let planetas = try JSONDecoder().decode([Planeta].self, from: datos)
        return planetas.sorted { $0.orden < $1.orden }
    }

    func registrarConsulta(planetaId: String) async {
        // La copia local no guarda consultas.
    }
}
