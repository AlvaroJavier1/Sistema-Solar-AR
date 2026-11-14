import SwiftUI
import RealityKit

/// Escena de realidad aumentada con el Sol y los planetas.
/// Requiere iOS 18 o superior y un iPhone real (el simulador no tiene cámara de RA).
struct ARSistemaSolarView: View {
    @Environment(PlanetasViewModel.self) private var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel
        let planetas = viewModel.planetas

        Group {
            if planetas.isEmpty {
                ProgressView("Cargando planetas…")
            } else {
                RealityView { content in
                    content.add(SistemaSolarFactory.crearEscena(planetas: planetas))
                }
                .gesture(
                    SpatialTapGesture()
                        .targetedToAnyEntity()
                        .onEnded { valor in
                            viewModel.seleccionarPlaneta(id: valor.entity.name)
                        }
                )
                .ignoresSafeArea()
                .overlay(alignment: .top) { instruccion }
            }
        }
        .sheet(item: $viewModel.seleccionado) { planeta in
            NavigationStack {
                PlanetaDetalleView(planeta: planeta)
            }
            .presentationDetents([.medium, .large])
        }
    }

    private var instruccion: some View {
        Text("Apunta a una mesa o al piso y toca un planeta")
            .font(.footnote)
            .padding(10)
            .background(.ultraThinMaterial, in: Capsule())
            .padding(.top, 8)
    }
}
