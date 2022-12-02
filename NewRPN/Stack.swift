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

enum KeyOperation {
    case none, delete, negate, exponent, add, subtract, multiply, divide
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
    // FIXME: Add mantisaText and exponentText. Add a state variable that
    // says if we are parsing mantisa or exponent. Change entryValueText
    // to getter that concatenates mantisaText and exponentText.
    var entryValueText: String {
        get {
            if (parsingMantisa) {
                return negateNumberString(mantisaText, negative: negateMantisa)
            } else {
                return negateNumberString(mantisaText, negative: negateMantisa)
                    + "E" + negateNumberString(exponentText, negative: negateExponent)
            }
        }
    }
    var mantisaText: String = ""
    var exponentText: String = ""
    var entryValue: Double = 0.0
    var stack: [Double] = []
    var parsingMantisa = true
    var negateMantisa = false
    var negateExponent = false
    let stackSize: Int = 4
    let validNumbers = "0123456789ABCDEF."
    let operationMap = ["+/-": KeyStroke(operation: .negate),
                        "DEL": KeyStroke(operation: .delete),
                        "EEX": KeyStroke(operation: .exponent),
                        "+": KeyStroke(operation: .add),
                        "-": KeyStroke(operation: .subtract),
                        "x": KeyStroke(operation: .multiply),
                        "/": KeyStroke(operation: .divide)]

    func negateNumberString(_ number: String, negative: Bool) -> String {
        if negative {
            return "-" + number
        } else {
            return number
        }
    }
    
    mutating func parse(_ keySymbol: String) {
        if validNumbers.contains(keySymbol) {
            if parsingMantisa {
                mantisaText += keySymbol
            } else {
                exponentText += keySymbol
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
                mantisaText = ""
                exponentText = ""
                negateMantisa = false
                negateExponent = false
                parsingMantisa = true
            case .exponent:
                if parsingMantisa {
                    parsingMantisa = false
                }
            case .add:
                entryValue = 0.0
            case .subtract:
                entryValue = 0.0
            case .multiply:
                entryValue = 0.0
            case .divide:
                entryValue = 0.0
            default:
                entryValue = 0.0
            }
        }
    }
}
