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

enum Format: Int {
    case standard, fixed, science, engineering
}

struct ValueFormat {
    var format: Format = .standard
    var radix: Radix = .decimal
    var displayAsHMS: Bool = false
    var decimalPlaces: Int = 3
    var integerWordSize: Int = 16
}

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

    // FIXME: Return nil of there was an error?
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
    
    func toHMS(_ t: Double) -> (Int, Int, Double) {
        var seconds = t
        let hours = Int(seconds / 3600.0)
        seconds -= Double(3600 * hours)
        let minutes = Int(seconds / 60.0)
        seconds -= Double(60 * minutes)
        return (hours, minutes, seconds)
    }
}
