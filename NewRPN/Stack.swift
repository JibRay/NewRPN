//
//  Stack.swift
//  NewRPN
//
//  Created by Jib Ray on 11/30/22.
//

import SwiftUI

enum KeyType {
    case number, operation
}

enum Radix {
    case octal, decimal, hexidecimal
}

enum KeyOperation {
    case none, delete, negate, exponent, add, subtract, multiply, divide, enter
}

struct StackItem {
    var empty: Bool = true
    var decimalValue: Double = 0.0
    var integerValue: Int64 = 0
}

struct KeyStroke {
    var type: KeyType = .number
    var value: Character = "0"
    var operation: KeyOperation = .none
    
    init(value: Character) {
        self.value = value
        type = .number
    }
    
    init(operation: KeyOperation) {
        self.operation = operation
        type = .operation
    }
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
    var entryValue: Double = 0.0
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
                        "ENTER": KeyStroke(operation: .enter)]

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
        } else {
            if stackItems[index].decimalValue > 999999999.999999
                || stackItems[index].decimalValue < -999999999.999999 {
                let formatter = NumberFormatter()
                formatter.numberStyle = .scientific
                formatter.positiveFormat = "0.######E+0"
                formatter.exponentSymbol = "e"
                if let etext = formatter.string(for: stackItems[index].decimalValue) {
                    text = etext
                } else {
                    text = ""
                }
            } else {
                text = String(format: "%0.6f", stackItems[index].decimalValue)
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
    
    mutating func pop() -> StackItem {
        let top = stackItems[0]
        for index in 1..<stackSize {
            stackItems[index - 1] = stackItems[index]
        }
        stackItems[stackSize - 1].empty = true
        return top
    }
    
    mutating func swap() {
        if !stackItems[0].empty && !stackItems[1].empty {
            let top = stackItems[0]
            stackItems[0] = stackItems[1]
            stackItems[1] = top
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
    
    // Accept the next keySymbol and parse mantisa and/or exponent.
    mutating func parse(_ keySymbol: String) {
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
        } else if let operationToken = operationMap[keySymbol] {
            switch operationToken.operation {
            case .negate:
                if parsingMantisa {
                    negateMantisa = !negateMantisa
                } else {
                    negateExponent = !negateExponent
                }
            case .delete:
                if mantisaText.count == 0 {
                    drop()
                }
                clearMantisa()
            case .exponent:
                if (mantisaText.count > 0 && radix == .decimal) {
                    parsingMantisa = false
                }
            case .add:
                // First see if there is a valid value in the mantisa.
                if let z = Double(mantisaText) {
                    if stackDepth() >= 1 {
                        let y = pop().decimalValue + z
                        push(StackItem(empty: false, decimalValue: y))
                    }
                } else if stackDepth() >= 2 {
                    let x = pop().decimalValue
                    stackItems[0].decimalValue += x
                }
                clearMantisa()
            case .subtract:
                // First see if there is a valid value in the mantisa.
                if let z = Double(mantisaText) {
                    if stackDepth() >= 1 {
                        let y = pop().decimalValue - z
                        push(StackItem(empty: false, decimalValue: y))
                    }
                } else if stackDepth() >= 2 {
                    let x = pop().decimalValue
                    stackItems[0].decimalValue -= x
                }
                clearMantisa()
            case .multiply:
                // First see if there is a valid value in the mantisa.
                if let z = Double(mantisaText) {
                    if stackDepth() >= 1 {
                        let y = pop().decimalValue * z
                        push(StackItem(empty: false, decimalValue: y))
                    }
                } else if stackDepth() >= 2 {
                    let x = pop().decimalValue
                    stackItems[0].decimalValue *= x
                }
                clearMantisa()
            case .divide:
                // First see if there is a valid value in the mantisa.
                if let z = Double(mantisaText) {
                    if stackDepth() >= 1 {
                        let y = pop().decimalValue / z
                        push(StackItem(empty: false, decimalValue: y))
                    }
                } else if stackDepth() >= 2 {
                    let x = pop().decimalValue
                    stackItems[0].decimalValue /= x
                }
                clearMantisa()
            case .enter:
                var text = negateMantisa ? "-" : ""
                text += mantisaText
                if exponentText.count > 0 {
                    text += "e"
                    text += negateExponent ? "-" : ""
                    text += exponentText
                }
                if let v = Double(text) {
                    push(StackItem(empty: false, decimalValue: v))
                } else {
                    push(stackItems[0])
                }
                mantisaText = ""
                exponentText = ""
                negateMantisa = false
                negateExponent = false
                parsingMantisa = true
            default:
                entryValue = 0.0
            }
        }
    }
}
