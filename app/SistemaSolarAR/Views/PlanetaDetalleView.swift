import SwiftUI

/// Ficha de un planeta: descripción, datos clave y curiosidad.
struct PlanetaDetalleView: View {
    let planeta: Planeta

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color(hex: planeta.colorHex))
                        .frame(width: 64, height: 64)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading) {
                        Text(planeta.nombre).font(.largeTitle.bold())
                        Text(planeta.tipo).foregroundStyle(.secondary)
                    }
                }

                Text(planeta.descripcion)

                GroupBox("Datos clave") {
                    VStack(spacing: 8) {
                        LabeledContent("Diámetro", value: "\(numero(planeta.diametroKm, decimales: 0)) km")
                        LabeledContent("Distancia al Sol", value: "\(numero(planeta.distanciaSolMillonesKm, decimales: 1)) millones de km")
                        LabeledContent("Duración de su órbita", value: "\(numero(planeta.periodoOrbitalDias, decimales: 1)) días")
                        LabeledContent("Lunas", value: planeta.lunas)
                        LabeledContent("Temperatura", value: planeta.temperatura)
                    }
                }

                GroupBox("Curiosidad") {
                    Text(planeta.curiosidad)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .navigationTitle(planeta.nombre)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func numero(_ valor: Double, decimales: Int) -> String {
        valor.formatted(.number.precision(.fractionLength(decimales)))
    }
}
