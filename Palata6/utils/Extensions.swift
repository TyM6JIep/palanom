import Foundation
import UIKit

extension UIColor {
    class open func colorFromHex(hex: Int) -> UIColor {
        var colorHex = hex
        var alpha = 0xff
        if hex > 0xffffff {
            colorHex = hex & 0x00ffffff
            alpha = hex >> 24
        }
        
        return UIColor(
            red: CGFloat((colorHex & 0xff0000) >> 16) / 255.0,
            green: CGFloat((colorHex & 0x00ff00) >> 8) / 255.0,
            blue: CGFloat((colorHex & 0x0000ff) >> 0) / 255.0,
            alpha: CGFloat(alpha) / 255.0
        )
    }
    
    class open func colorFromHex(hex: Int, alpha: Float) -> UIColor {
        var colorHex = hex
        if hex > 0xffffff {
            colorHex = hex & 0x00ffffff
        }
        
        return UIColor(
            red: CGFloat((colorHex & 0xff0000) >> 16) / 255.0,
            green: CGFloat((colorHex & 0x00ff00) >> 8) / 255.0,
            blue: CGFloat((colorHex & 0x0000ff) >> 0) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension DateFormatter {
    convenience init(mask: String) {
        self.init()
        self.dateFormat = mask
    }
}
