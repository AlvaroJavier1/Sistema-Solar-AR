import SwiftUI

struct ContentView: View {
    @Environment(PlanetasViewModel.self) private var viewModel

    var body: some View {
        TabView {
            NavigationStack {
                PlanetaListView()
            }
            .tabItem { Label("Planetas", systemImage: "list.bullet") }

            ARSistemaSolarView()
                .tabItem { Label("Realidad aumentada", systemImage: "arkit") }
        }
        .task { await viewModel.cargar() }
    }
}
