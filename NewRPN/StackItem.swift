//
//  StackItem.swift
//  NewRPN
//
//  Created by Jib Ray on 12/26/22.
//

import SwiftUI

enum Radix: Int {
    case octal = 8
    case decimal = 10
    case hexidecimal = 16
}

enum Format: String {
    case standard = "STD"
    case fixed = "FIX"
    case science = "SCI"
    case engineering = "ENG"
}

struct ValueFormat {
    var format: Format = .standard
    var radix: Radix = .decimal
    var displayAsHMS: Bool = false
    var decimalPlaces: Int = 3
    var integerWordSize: Int = 16
}

// Stack items contain a stack value. It contains two internal values:
// decimalValue and integerValue. These are kept in sync as much as
// possible. text() returns a formatted representation of either
// decimalValue or integerValue depending on format selections.
struct StackItem {
    var empty: Bool = true
    var _decimalValue: Double = 0.0
    var decimalValue: Double {
        get { return _decimalValue }
        set {
            _decimalValue = newValue
            if _decimalValue >= Double(Int64.max) {
                _integerValue = Int64.max
            } else if _decimalValue <= Double(-Int64.max) {
                _integerValue = -Int64.max
            } else {
                _integerValue = Int64(decimalValue)
            }
        }
    }
    var _integerValue: Int64 = 0
    var integerValue: Int64 {
        get { return _integerValue }
        set {
            _integerValue = newValue
            _decimalValue = Double(newValue)
        }
    }
    init() {
        empty = true
        _decimalValue = 0.0
        _integerValue = 0
    }
    init(decimalValue: Double) {
        self.empty = false
        self.decimalValue = decimalValue
    }
    init(integerValue: Int64) {
        self.empty = false
        self.integerValue = integerValue
    }

    // Format H:M:S, decimalValue or integerValue depending on the value
    // of the format argument.
    func text(format: ValueFormat) -> String {
        if empty {
            return ""
        } else if format.displayAsHMS {
            let hms = toHMS(decimalValue)
            let formatString: String = "%0d:%02d:%0.\(format.decimalPlaces)f"
            return String(format: formatString, hms.0, hms.1, hms.2)
        } else {
            switch format.format {
            case .standard:
                return standardText(format: format)
            case .fixed:
                return fixedText(format: format)
            case .science:
                return scienceText(format: format)
            case .engineering:
                return engineeringText(format: format)
            }
        }
    }
    
    // FIXME: change this formatting to use same logic as engineering.
    // Format decimalValue or integerValue depending on format.radix.
    func standardText(format: ValueFormat) -> String {
        var text = ""

        switch format.radix {
        case .decimal:
            if ((decimalValue < 0.00000001 && decimalValue > 0.0)
                || (decimalValue > 999999999.999999)
                || (decimalValue < -999999999.999999)
                || (decimalValue > -0.00000001) && decimalValue < 0.0) {
                let formatter = NumberFormatter()
                formatter.numberStyle = .scientific
                formatter.positiveFormat = "0.########E+0"
                formatter.exponentSymbol = "e"
                if let etext = formatter.string(for: decimalValue) {
                    text = etext
                } else {
                    text = ""
                }
            } else {
                text = String(format: "%0.8f", decimalValue)
            }
        case .octal:
            text = String(format: "o:%O", integerValue)
        case .hexidecimal:
            text = String(format: "h:%X", integerValue)
        }

        return text
    }
    
    func fixedText(format: ValueFormat) -> String {
        let formatString: String = "%0.\(format.decimalPlaces)f"
        return String(format: formatString, decimalValue)
    }
    
    // Format decimalValue in exponential form.
    func scienceText(format: ValueFormat) -> String {
        var formatString = "0."
        for _ in (0..<format.decimalPlaces) {
            formatString += "#"
        }
        formatString += "E+0"
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = formatString
        formatter.exponentSymbol = "e"
        if let text = formatter.string(for: decimalValue) {
            return text
        } else {
            return ""
        }
    }
    
    // Format decimalValue such that the mantisa magnitude is in the range
    // 0 - 999 and the exponent is a multiple of 3.
    func engineeringText(format: ValueFormat) -> String {
        var x = decimalValue
        var negative = false
        if decimalValue < 0.0 {
            x = -decimalValue
            negative = true
        }
        var outputExponent: Int
        var text = ""
        var formatString: String = negative ? "-" : ""
        formatString += "%0.\(format.decimalPlaces)f"
        // Compute the exponent and format string for both
        // the > 1 and < 1 cases. The exponent is computed to
        // always be a multiple of 3.
        if log10(x) < 0 {
            outputExponent = 3 + Int(-log10(x) / 3.0) * 3
            text = String(format: formatString, x * pow(10.0, Double(outputExponent)))
            if outputExponent != 0 {
                text += "e-\(outputExponent)"
            }
        } else {
            outputExponent = Int(log10(x) / 3.0) * 3
            text = String(format: formatString, x / pow(10.0, Double(outputExponent)))
            if outputExponent != 0 {
                text += "e\(outputExponent)"
            }
        }
        return text
    }
    
    // Return a tuple that is decimalValue hours converted to hours,
    // minutes, seconds.
    func toHMS(_ t: Double) -> (Int, Int, Double) {
        var t0 = t
        let hours = Int(t0)
        t0 -= Double(hours)
        let minutes = Int(t0 * 60.0)
        t0 -= Double(minutes) / 60.0
        let seconds = t0 * 3600.0
        
        /*
        var seconds = t
        let hours = Int(seconds / 3600.0)
        seconds -= Double(3600 * hours)
        let minutes = Int(seconds / 60.0)
        seconds -= Double(60 * minutes)
         */
        
        return (hours, minutes, seconds)
    }
}
