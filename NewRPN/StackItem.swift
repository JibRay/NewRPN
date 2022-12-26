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

    func text(format: ValueFormat) -> String {
        switch format.format {
        case .standard:
            return standardText(format: format)
        case .fixed:
            return fixedText(format: format)
        case .science, .engineering:
            return scienceText(format: format)
        }
    }
    
    func standardText(format: ValueFormat) -> String {
        var text = ""
        if empty {
            return ""
        } else {
            switch format.radix {
                case .decimal:
                if format.displayAsHMS {
                    let hms = toHMS(decimalValue)
                    text = String(format: "%0d:%02d:%0.8f", hms.0, hms.1, hms.2)
                } else if ((decimalValue < 0.00000001 && decimalValue > 0.0)
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
            }
        return text
    }
    
    func fixedText(format: ValueFormat) -> String {
        if empty {
            return ""
        }
        let formatString: String = "%0.\(format.decimalPlaces)f"
        return String(format: formatString, decimalValue)
    }
    
    func scienceText(format: ValueFormat) -> String {
        return ""
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