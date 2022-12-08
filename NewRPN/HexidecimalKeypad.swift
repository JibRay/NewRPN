//
//  HexidecimalKeypad.swift
//  NewRPN
//
//  Created by Jib Ray on 12/8/22.
//

import SwiftUI

struct HexidecimalKeypad: Keypad {
    @Binding var stack: Stack
    let fontSize: CGFloat = 25
    // This keypad's operations.
    let operationMap = ["+/-": KeyStroke(operation: .negate),
                        "DEL": KeyStroke(operation: .delete),
                        "+": KeyStroke(operation: .add),
                        "-": KeyStroke(operation: .subtract),
                        "x": KeyStroke(operation: .multiply),
                        "/": KeyStroke(operation: .divide),
                        "ENTER": KeyStroke(operation: .enter)]

    // Buttons displayed by this keypad.
    let key: [[Key]] = [
        [Key((5,5), symbol: "ENTER", columns: 2, color: Color(.gray)),
         Key((5,5), symbol: "+/-", color: Color(.gray)),
         Key((5,5), symbol: "DEL", columns: 2, color: Color(.gray))],
        
        [Key((5,5), symbol: "C", color: Color(.brown)),
         Key((5,5), symbol: "D", color: Color(.brown)),
         Key((5,5), symbol: "E", color: Color(.brown)),
         Key((5,5), symbol: "F", color: Color(.brown)),
         Key((5,5), symbol: "/", color: Color(.orange))],
        
        [Key((5,5), symbol: "8", color: Color(.brown)),
         Key((5,5), symbol: "9", color: Color(.brown)),
         Key((5,5), symbol: "A", color: Color(.brown)),
         Key((5,5), symbol: "B", color: Color(.brown)),
         Key((5,5), symbol: "x", color: Color(.orange))],

        [Key((5,5), symbol: "4", color: Color(.brown)),
         Key((5,5), symbol: "5", color: Color(.brown)),
         Key((5,5), symbol: "6", color: Color(.brown)),
         Key((5,5), symbol: "7", color: Color(.brown)),
         Key((5,5), symbol: "-", color: Color(.orange))],
        
        [Key((5,5), symbol: "0", color: Color(.brown)),
         Key((5,5), symbol: "1", color: Color(.brown)),
         Key((5,5), symbol: "2", color: Color(.brown)),
         Key((5,5), symbol: "3", color: Color(.brown)),
         Key((5,5), symbol: "+", color: Color(.orange))]
    ]
    
    func parse(_ keySymbol: String) -> Bool {
        stack.radix = .hexidecimal
        if stack.parse(keySymbol) {
            return true
        }
        if let operationToken = operationMap[keySymbol] {
            switch operationToken.operation {
            case .negate:
                stack.negateMantisa = !stack.negateMantisa
            case .delete:
                if stack.mantisaText.count == 0 {
                    stack.drop()
                }
                stack.clearMantisa()
            case .add:
                // First see if there is a valid value in the mantisa.
                if let x = Int64(stack.mantisaText, radix: 16) {
                    if stack.stackDepth() >= 1 {
                        let y = stack.pop()!.integerValue + x
                        stack.push(StackItem(integerValue: y))
                    }
                } else if stack.stackDepth() >= 2 {
                    let x = stack.pop()!.integerValue
                    stack.stackItems[0].integerValue += x
                }
                stack.clearMantisa()
            case .subtract:
                // First see if there is a valid value in the mantisa.
                if let x = Int64(stack.mantisaText, radix: 16) {
                    if stack.stackDepth() >= 1 {
                        let y = stack.pop()!.integerValue - x
                        stack.push(StackItem(integerValue: y))
                    }
                } else if stack.stackDepth() >= 2 {
                    let x = stack.pop()!.integerValue
                    stack.stackItems[0].integerValue -= x
                }
                stack.clearMantisa()
            case .multiply:
                // First see if there is a valid value in the mantisa.
                if let z = Int64(stack.mantisaText, radix: 16) {
                    if stack.stackDepth() >= 1 {
                        let y = stack.pop()!.integerValue * z
                        stack.push(StackItem(integerValue: y))
                    }
                } else if stack.stackDepth() >= 2 {
                    let x = stack.pop()!.integerValue
                    stack.stackItems[0].integerValue *= x
                }
                stack.clearMantisa()
            case .divide:
                // First see if there is a valid value in the mantisa.
                if let z = Int64(stack.mantisaText, radix: 16) {
                    if stack.stackDepth() >= 1 {
                        let y = stack.pop()!.integerValue / z
                        stack.push(StackItem(integerValue: y))
                    }
                } else if stack.stackDepth() >= 2 {
                    let x = stack.pop()!.integerValue
                    stack.stackItems[0].integerValue /= x
                }
                stack.clearMantisa()
            case .enter:
                var text = stack.negateMantisa ? "-" : ""
                text += stack.mantisaText
                if let v = Int64(text, radix: 16) {
                    stack.push(StackItem(integerValue: v))
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

