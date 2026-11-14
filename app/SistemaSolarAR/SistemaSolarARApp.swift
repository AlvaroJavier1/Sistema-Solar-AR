import SwiftUI
import FirebaseCore

@main
struct SistemaSolarARApp: App {
    @State private var viewModel: PlanetasViewModel

    init() {
        // Requiere el archivo GoogleService-Info.plist dentro del proyecto.
        FirebaseApp.configure()
        _viewModel = State(initialValue: PlanetasViewModel())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
    }
}
