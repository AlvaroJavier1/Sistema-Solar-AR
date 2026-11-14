import SwiftUI
import UIKit

extension UIColor {
    /// Crea un color a partir de un texto hexadecimal, por ejemplo "#2E7BD6".
    convenience init(hex: String) {
        let limpio = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var valor: UInt64 = 0
        Scanner(string: limpio).scanHexInt64(&valor)
        let rojo = CGFloat((valor >> 16) & 0xFF) / 255
        let verde = CGFloat((valor >> 8) & 0xFF) / 255
        let azul = CGFloat(valor & 0xFF) / 255
        self.init(red: rojo, green: verde, blue: azul, alpha: 1)
    }
}

extension Color {
    init(hex: String) {
        self.init(uiColor: UIColor(hex: hex))
    }
}
