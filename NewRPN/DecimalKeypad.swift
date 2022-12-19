//
//  decimalKeypad.swift
//  NewRPN
//
//  Created by Jib Ray on 12/5/22.
//

import SwiftUI

struct DecimalKeypad: Keypad {
    @Binding var stack: Stack
    let fontSize: CGFloat = 25
    // This keypad's operations.
    let operationMap = ["STD": KeyStroke(operation: .std),
                        "FIX": KeyStroke(operation: .fix),
                        "SCI": KeyStroke(operation: .sci),
                        "ENG": KeyStroke(operation: .eng),
                        "+/-": KeyStroke(operation: .negate),
                        "DEL": KeyStroke(operation: .delete),
                        "EEX": KeyStroke(operation: .exponent),
                        "+": KeyStroke(operation: .add),
                        "-": KeyStroke(operation: .subtract),
                        "x": KeyStroke(operation: .multiply),
                        "divide": KeyStroke(operation: .divide),
                        "ENTER": KeyStroke(operation: .enter)]

    // Buttons displayed by this keypad.
    let key: [[Key]] = [
        [Key((5,4), symbol: "STD", color: Color.AppColor.enter),
         Key((5,4), symbol: "FIX", color: Color.AppColor.enter),
         Key((5,4), symbol: "SCI", color: Color.AppColor.enter),
         Key((5,4), symbol: "ENG", color: Color.AppColor.enter)],
        
        [Key((5,4), symbol: "ENTER", columns: 2, color: Color.AppColor.enter),
         Key((5,4), symbol: "+/-", color: Color.AppColor.enter),
         Key((5,4), symbol: "EEX", color: Color.AppColor.enter)],
        
        [Key((5,4), symbol: "7", color: Color.AppColor.numbers),
         Key((5,4), symbol: "8", color: Color.AppColor.numbers),
         Key((5,4), symbol: "9", color: Color.AppColor.numbers),
         Key((5,4), icon: .systemSymbol, symbol: "divide", color: Color.AppColor.operators)],
        
        [Key((5,4), symbol: "4", color: Color.AppColor.numbers),
         Key((5,4), symbol: "5", color: Color.AppColor.numbers),
         Key((5,4), symbol: "6", color: Color.AppColor.numbers),
         Key((5,4), symbol: "x", color: Color.AppColor.operators)],
        
        [Key((5,4), symbol: "1", color: Color.AppColor.numbers),
         Key((5,4), symbol: "2", color: Color.AppColor.numbers),
         Key((5,4), symbol: "3", color: Color.AppColor.numbers),
         Key((5,4), symbol: "-", color: Color.AppColor.operators)],
        
        [Key((5,4), symbol: "0", color: Color.AppColor.numbers),
         Key((5,4), symbol: ".", color: Color.AppColor.numbers),
         Key((5,4), symbol: "DEL", color: Color.AppColor.enter),
         Key((5,4), symbol: "+", color: Color.AppColor.operators)]
    ]
    
    func parse(_ keySymbol: String) -> Bool {
        stack.radix = .decimal
        if stack.parse(keySymbol) {
            return true
        }
        if let operationToken = operationMap[keySymbol] {
            switch operationToken.operation {
            case .negate:
                if stack.parsingMantisa {
                    stack.negateMantisa = !stack.negateMantisa
                } else {
                    stack.negateExponent = !stack.negateExponent
                }
            case .delete:
                if stack.mantisaText.count == 0 {
                    stack.drop()
                }
                stack.clearMantisa()
            case .exponent:
                stack.parsingMantisa = false
            case .add:
                // First see if there is a valid value in the mantisa.
                if let z = Double(stack.mantisaText) {
                    if stack.stackDepth() >= 1 {
                        let y = stack.pop()!.decimalValue + z
                        stack.push(StackItem(decimalValue: y))
                    }
                } else if stack.stackDepth() >= 2 {
                    let x = stack.pop()!.decimalValue
                    stack.stackItems[0].decimalValue += x
                }
                stack.clearMantisa()
            case .subtract:
                // First see if there is a valid value in the mantisa.
                if let z = Double(stack.mantisaText) {
                    if stack.stackDepth() >= 1 {
                        let y = stack.pop()!.decimalValue - z
                        stack.push(StackItem(decimalValue: y))
                    }
                } else if stack.stackDepth() >= 2 {
                    let x = stack.pop()!.decimalValue
                    stack.stackItems[0].decimalValue -= x
                }
                stack.clearMantisa()
            case .multiply:
                // First see if there is a valid value in the mantisa.
                if let z = Double(stack.mantisaText) {
                    if stack.stackDepth() >= 1 {
                        let y = stack.pop()!.decimalValue * z
                        stack.push(StackItem(decimalValue: y))
                    }
                } else if stack.stackDepth() >= 2 {
                    let x = stack.pop()!.decimalValue
                    stack.stackItems[0].decimalValue *= x
                }
                stack.clearMantisa()
            case .divide:
                // First see if there is a valid value in the mantisa.
                if let z = Double(stack.mantisaText) {
                    if stack.stackDepth() >= 1 {
                        let y = stack.pop()!.decimalValue / z
                        stack.push(StackItem(decimalValue: y))
                    }
                } else if stack.stackDepth() >= 2 {
                    let x = stack.pop()!.decimalValue
                    stack.stackItems[0].decimalValue /= x
                }
                stack.clearMantisa()
            case .enter:
                var text = stack.negateMantisa ? "-" : ""
                text += stack.mantisaText
                if stack.exponentText.count > 0 {
                    text += "e"
                    text += stack.negateExponent ? "-" : ""
                    text += stack.exponentText
                }
                if let v = Double(text) {
                    stack.push(StackItem(decimalValue: v))
                } else {
                    stack.push(stack.stackItems[0])
                }
                stack.clearMantisa()
            default:
                stack.clearMantisa()
            }
            return true
        }
        return false
    }
}

