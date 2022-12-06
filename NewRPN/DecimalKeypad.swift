//
//  decimalKeypad.swift
//  NewRPN
//
//  Created by Jib Ray on 12/5/22.
//

import SwiftUI

struct DecimalKeypad: Keypad {
    @Binding var stack: Stack
    let fontSize: CGFloat = 32
    var mantisaText: String = ""
    var exponentText: String = ""
    var radix: Radix = .decimal // FIXME: Just decimal for now.
    var entryValue: Double = 0.0
    var parsingMantisa = true
    var negateMantisa = false
    var negateExponent = false
    let validNumbers = "0123456789."
    let operationMap = ["+/-": KeyStroke(operation: .negate),
                        "DEL": KeyStroke(operation: .delete),
                        "EEX": KeyStroke(operation: .exponent),
                        "+": KeyStroke(operation: .add),
                        "-": KeyStroke(operation: .subtract),
                        "x": KeyStroke(operation: .multiply),
                        "/": KeyStroke(operation: .divide),
                        "ENTER": KeyStroke(operation: .enter)]

    let key: [[Key]] = [
        [Key((5,4), symbol: "ENTER", columns: 2, color: Color(.gray)),
         Key((5,4), symbol: "+/-", color: Color(.gray)),
         Key((5,4), symbol: "EEX", color: Color(.gray))],
        
        [Key((5,4), symbol: "7", color: Color(.brown)),
         Key((5,4), symbol: "8", color: Color(.brown)),
         Key((5,4), symbol: "9", color: Color(.brown)),
         Key((5,4), symbol: "/", color: Color(.orange))],
        
        [Key((5,4), symbol: "4", color: Color(.brown)),
         Key((5,4), symbol: "5", color: Color(.brown)),
         Key((5,4), symbol: "6", color: Color(.brown)),
         Key((5,4), symbol: "x", color: Color(.orange))],
        
        [Key((5,4), symbol: "1", color: Color(.brown)),
         Key((5,4), symbol: "2", color: Color(.brown)),
         Key((5,4), symbol: "3", color: Color(.brown)),
         Key((5,4), symbol: "-", color: Color(.orange))],
        
        [Key((5,4), symbol: "0", color: Color(.brown)),
         Key((5,4), symbol: ".", color: Color(.brown)),
         Key((5,4), symbol: "DEL", color: Color(.gray)),
         Key((5,4), symbol: "+", color: Color(.orange))]
    ]
    
    mutating func clearMantisa() {
        mantisaText = ""
        exponentText = ""
        negateMantisa = false
        negateExponent = false
        parsingMantisa = true
    }
    
    // Accept the next keySymbol and parse mantisa and/or exponent.
    mutating func parse(_ keySymbol: String) {
        if validNumbers.contains(keySymbol) {
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
                    stack.drop()
                }
                clearMantisa()
            case .exponent:
                parsingMantisa = false
            case .add:
                // First see if there is a valid value in the mantisa.
                if let z = Double(mantisaText) {
                    if stack.stackDepth() >= 1 {
                        let y = stack.pop().decimalValue + z
                        stack.push(StackItem(empty: false, decimalValue: y))
                    }
                } else if stack.stackDepth() >= 2 {
                    let x = stack.pop().decimalValue
                    stack.stackItems[0].decimalValue += x
                }
                clearMantisa()
            case .subtract:
                // First see if there is a valid value in the mantisa.
                if let z = Double(mantisaText) {
                    if stack.stackDepth() >= 1 {
                        let y = stack.pop().decimalValue - z
                        stack.push(StackItem(empty: false, decimalValue: y))
                    }
                } else if stack.stackDepth() >= 2 {
                    let x = stack.pop().decimalValue
                    stack.stackItems[0].decimalValue -= x
                }
                clearMantisa()
            case .multiply:
                // First see if there is a valid value in the mantisa.
                if let z = Double(mantisaText) {
                    if stack.stackDepth() >= 1 {
                        let y = stack.pop().decimalValue * z
                        stack.push(StackItem(empty: false, decimalValue: y))
                    }
                } else if stack.stackDepth() >= 2 {
                    let x = stack.pop().decimalValue
                    stack.stackItems[0].decimalValue *= x
                }
                clearMantisa()
            case .divide:
                // First see if there is a valid value in the mantisa.
                if let z = Double(mantisaText) {
                    if stack.stackDepth() >= 1 {
                        let y = stack.pop().decimalValue / z
                        stack.push(StackItem(empty: false, decimalValue: y))
                    }
                } else if stack.stackDepth() >= 2 {
                    let x = stack.pop().decimalValue
                    stack.stackItems[0].decimalValue /= x
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
                    stack.push(StackItem(empty: false, decimalValue: v))
                } else {
                    stack.push(stack.stackItems[0])
                }
                clearMantisa()
            default:
                entryValue = 0.0
            }
        }
    }
}

