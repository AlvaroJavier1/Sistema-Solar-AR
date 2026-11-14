import SwiftUI

struct PlanetaListView: View {
    @Environment(PlanetasViewModel.self) private var viewModel

    var body: some View {
        List(viewModel.planetas) { planeta in
            NavigationLink(value: planeta) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color(hex: planeta.colorHex))
                        .frame(width: 28, height: 28)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading) {
                        Text(planeta.nombre).font(.headline)
                        Text(planeta.tipo)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Sistema Solar")
        .navigationDestination(for: Planeta.self) { planeta in
            PlanetaDetalleView(planeta: planeta)
        }
        .overlay {
            if viewModel.cargando {
                ProgressView("Cargando…")
            }
        }
        .safeAreaInset(edge: .bottom) {
            if let aviso = viewModel.aviso {
                Text(aviso)
                    .font(.footnote)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
            }
        }
    }
}
