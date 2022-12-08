//
//  Stack.swift
//  NewRPN
//
//  Created by Jib Ray on 11/30/22.
//

import SwiftUI

enum Radix {
    case octal, decimal, hexidecimal
}

struct StackItem {
    var empty: Bool = true
    var decimalValue: Double = 0.0
    var integerValue: Int64 = 0
}

struct Stack {
    let stackSize = 5
    // Top of the stack is [0] and bottom is [4].
    var stackItems = [StackItem](repeating: StackItem(), count: 5)
    var entryValueText: String {
        get {
            if (parsingMantisa) {
                return negateNumberString(mantisaText, negative: negateMantisa)
            } else {
                return negateNumberString(mantisaText, negative: negateMantisa)
                    + "e" + negateNumberString(exponentText, negative: negateExponent)
            }
        }
    }
    
    // FIXME: For now everything is assumed to be decimal.
    var radix: Radix = .decimal
    
    var mantisaText: String = ""
    var exponentText: String = ""
    var parsingMantisa = true
    var negateMantisa = false
    var negateExponent = false
    let validOctalNumbers = "01234567"
    let validDecimalNumbers = "0123456789."
    let validHexNumbers = "0123456789ABCDEF"
    let operationMap = ["+/-": KeyStroke(operation: .negate),
                        "DEL": KeyStroke(operation: .delete),
                        "EEX": KeyStroke(operation: .exponent),
                        "+": KeyStroke(operation: .add),
                        "-": KeyStroke(operation: .subtract),
                        "x": KeyStroke(operation: .multiply),
                        "/": KeyStroke(operation: .divide),
                        "ENTER": KeyStroke(operation: .enter),
                        "OVER": KeyStroke(operation: .over),
                        "SWAP": KeyStroke(operation: .swap),
                        "PICK": KeyStroke(operation: .pick),
                        "DROP": KeyStroke(operation: .drop)]

    mutating func getEntryOrStackValue() -> Double? {
        var value: Double? = 0.0
        var text = negateMantisa ? "-" : ""
        text += mantisaText
        if exponentText.count > 0 {
            text += "e"
            text += negateExponent ? "-" : ""
            text += exponentText
        }
        if let v = Double(text) {
            value = v
        } else {
            value = pop()!.decimalValue
        }
        clearMantisa()
        return value
    }
    
    // If negative is true prepend a "-" number.
    func negateNumberString(_ number: String, negative: Bool) -> String {
        if negative {
            return "-" + number
        } else {
            return number
        }
    }
    
    // FIXME: using this fails to compile.
    func scienticFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = "0.######E+0"
        formatter.exponentSymbol = "e"
        return formatter
    }
    
    func stackItemText(_ index: Int) -> String {
        var text = ""
        if stackItems[index].empty {
            return ""
        } else { // FIXME: Values do not display correctly in all cases.
            if ((stackItems[index].decimalValue < 0.00000001 && stackItems[index].decimalValue > 0.0)
                || (stackItems[index].decimalValue > 999999999.999999)
                || (stackItems[index].decimalValue < -999999999.999999)
                || (stackItems[index].decimalValue > -0.00000001) && stackItems[index].decimalValue < 0.0) {
                let formatter = NumberFormatter()
                formatter.numberStyle = .scientific
                formatter.positiveFormat = "0.########E+0"
                formatter.exponentSymbol = "e"
                if let etext = formatter.string(for: stackItems[index].decimalValue) {
                    text = etext
                } else {
                    text = ""
                }
            } else {
                text = String(format: "%0.8f", stackItems[index].decimalValue)
            }
        }
        return text
    }
    
    mutating func clearMantisa() {
        mantisaText = ""
        exponentText = ""
        negateMantisa = false
        negateExponent = false
        parsingMantisa = true
    }
    
    func stackDepth() -> Int {
        var depth = 0
        for index in 0..<stackSize {
            if stackItems[index].empty {
                return depth
            } else {
                depth += 1
            }
        }
        return depth
    }
    
    mutating func push(_ item: StackItem) {
        for index in stride(from: stackSize - 1, through: 1, by: -1) {
            stackItems[index] = stackItems[index - 1]
        }
        stackItems[0] = item
    }
    
    mutating func pop() -> StackItem? {
        let top = stackItems[0]
        for index in 1..<stackSize {
            stackItems[index - 1] = stackItems[index]
        }
        stackItems[stackSize - 1].empty = true
        return top
    }
    
    mutating func over() {
        if !stackItems[1].empty {
            push(stackItems[1])
        }
    }
    
    mutating func swap() {
        if !stackItems[0].empty && !stackItems[1].empty {
            let top = stackItems[0]
            stackItems[0] = stackItems[1]
            stackItems[1] = top
        }
    }
    
    mutating func pick(_ item: Int) {
        if item < stackSize && !stackItems[item].empty {
            push(stackItems[item])
        }
    }
    
    mutating func drop() {
        _ = pop()
    }
    
    mutating func pick(index: Int) {
        if index < stackSize && !stackItems[index].empty {
            let item = stackItems[index]
            push(item)
        }
    }
    
    // If keySymbol is a valid number in the current radix,
    // process it and return true. Otherwise return false.
    mutating func parse(_ keySymbol: String) -> Bool {
        if radix == .octal && validOctalNumbers.contains(keySymbol)
            || radix == .decimal && validDecimalNumbers.contains(keySymbol)
            || radix == .hexidecimal && validHexNumbers.contains(keySymbol) {
            if parsingMantisa {
                if mantisaText.count < 15 {
                    mantisaText += keySymbol
                }
            } else {
                if exponentText.count < 3 && keySymbol != "." {
                    exponentText += keySymbol
                }
            }
            return true
        }
        return false
    }
}
