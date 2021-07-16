import Foundation



public extension Double {
    
    func rounded(toMultiple multiple: Double) -> Double {
        let value = self / multiple
        return value.rounded() * multiple
    }
    
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func printToDecimal(_ fractionDigits: Int) -> String {
        return String(format: "%.\(fractionDigits)f", self.roundToDecimal(fractionDigits))
    }

}




public extension CGFloat {
    
    static var tau: CGFloat {
        return CGFloat.pi * 2.0
    }

    func rounded(toMultiple multiple: CGFloat) -> CGFloat {
        let value = self / multiple
        return value.rounded() * multiple
    }
    
    func roundToDecimal(_ fractionDigits: Int) -> CGFloat {
        let multiplier = pow(10, CGFloat(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func printToDecimal(_ fractionDigits: Int) -> String {
        return String(format: "%.\(fractionDigits)f", self.roundToDecimal(fractionDigits))
    }

}
