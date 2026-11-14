import Foundation
import Observation

/// MVVM: ViewModel. Carga los datos y gestiona el planeta seleccionado.
@MainActor
@Observable
final class PlanetasViewModel {
    private(set) var planetas: [Planeta] = []
    private(set) var cargando = false
    private(set) var aviso: String?
    var seleccionado: Planeta?

    private let remoto: PlanetasRepository
    private let local: PlanetasRepository

    init(
        remoto: PlanetasRepository = FirestorePlanetasRepository(),
        local: PlanetasRepository = LocalPlanetasRepository()
    ) {
        self.remoto = remoto
        self.local = local
    }

    /// Intenta cargar desde Firestore; si falla, usa la copia local.
    func cargar() async {
        guard planetas.isEmpty, !cargando else { return }
        cargando = true
        aviso = nil

        do {
            let datos = try await remoto.obtenerPlanetas()
            if datos.isEmpty { throw RepositorioError.sinDatos }
            planetas = datos
        } catch {
            await cargarCopiaLocal()
        }

        cargando = false
    }

    private func cargarCopiaLocal() async {
        do {
            planetas = try await local.obtenerPlanetas()
            aviso = "Mostrando datos locales (sin conexión con Firestore)."
        } catch {
            aviso = "No se pudieron cargar los datos."
        }
    }

    /// Se llama al tocar un planeta en la escena de RA.
    func seleccionarPlaneta(id: String) {
        guard let planeta = planetas.first(where: { $0.id == id }) else { return }
        seleccionado = planeta
        Task { await remoto.registrarConsulta(planetaId: planeta.id) }
    }
}
