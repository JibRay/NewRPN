//
//  IntegerKeypad.swift
//  NewRPN
//
//  Created by Jib Ray on 12/8/22.
//

import SwiftUI

struct IntegerKeypad: Keypad {
    @Binding var stack: Stack
    let fontSize: CGFloat = 25
    // @State var radix: Radix = .decimal
    
    // This keypad's operations.
    let operationMap = ["+/-": KeyStroke(operation: .negate),
                        "DEL": KeyStroke(operation: .delete),
                        "+": KeyStroke(operation: .add),
                        "-": KeyStroke(operation: .subtract),
                        "x": KeyStroke(operation: .multiply),
                        "divide": KeyStroke(operation: .divide),
                        "ENTER": KeyStroke(operation: .enter)]

    // Buttons displayed by this keypad.
    let key: [[Key]] = [
        [Key((5,5), symbol: "ENTER", columns: 2, color: Color.AppColor.enter),
         Key((5,5), symbol: "+/-", color: Color.AppColor.enter),
         Key((5,5), symbol: "DEL", columns: 2, color: Color.AppColor.enter)],
        
        [Key((5,5), symbol: "C", color: Color.AppColor.numbers),
         Key((5,5), symbol: "D", color: Color.AppColor.numbers),
         Key((5,5), symbol: "E", color: Color.AppColor.numbers),
         Key((5,5), symbol: "F", color: Color.AppColor.numbers),
         Key((5,5), icon: .systemSymbol, symbol: "divide", color: Color.AppColor.operators)],
        
        [Key((5,5), symbol: "8", color: Color.AppColor.numbers),
         Key((5,5), symbol: "9", color: Color.AppColor.numbers),
         Key((5,5), symbol: "A", color: Color.AppColor.numbers),
         Key((5,5), symbol: "B", color: Color.AppColor.numbers),
         Key((5,5), symbol: "x", color: Color.AppColor.operators)],

        [Key((5,5), symbol: "4", color: Color.AppColor.numbers),
         Key((5,5), symbol: "5", color: Color.AppColor.numbers),
         Key((5,5), symbol: "6", color: Color.AppColor.numbers),
         Key((5,5), symbol: "7", color: Color.AppColor.numbers),
         Key((5,5), symbol: "-", color: Color.AppColor.operators)],
        
        [Key((5,5), symbol: "0", color: Color.AppColor.numbers),
         Key((5,5), symbol: "1", color: Color.AppColor.numbers),
         Key((5,5), symbol: "2", color: Color.AppColor.numbers),
         Key((5,5), symbol: "3", color: Color.AppColor.numbers),
         Key((5,5), symbol: "+", color: Color.AppColor.operators)]
    ]
    
    func parse(_ keySymbol: String) -> Bool {
        stack.message = ""
        if stack.parse(keySymbol) {
            return true // If stack handled it, we're done.
        }
        if let operationToken = operationMap[keySymbol] {
            switch operationToken.operation {
            case .selectOctal:
                stack.valueFormat.radix = .octal
                stack.entryValuePrefix = "o:"
            case .selectDecimal:
                stack.valueFormat.radix = .decimal
                stack.entryValuePrefix = ""
            case .selectHexadecimal:
                stack.valueFormat.radix = .hexidecimal
                stack.entryValuePrefix = "h:"
            case .switchRadix:
                switch stack.valueFormat.radix {
                case .octal:
                    stack.clearMantisa()
                    stack.valueFormat.radix = .decimal
                case .decimal:
                    stack.clearMantisa()
                    stack.valueFormat.radix = .hexidecimal
                case .hexidecimal:
                    stack.clearMantisa()
                    stack.valueFormat.radix = .octal
                }
            case .negate:
                stack.negateMantisa = !stack.negateMantisa
            case .delete:
                if stack.mantisaText.count == 0 {
                    stack.drop()
                }
                stack.clearMantisa()
            case .add:
                // First see if there is a valid value in the mantisa.
                if let x = Int64(stack.mantisaText, radix: stack.valueFormat.radix.rawValue) {
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
                if let x = Int64(stack.mantisaText, radix: stack.valueFormat.radix.rawValue) {
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
                if let z = Int64(stack.mantisaText, radix: stack.valueFormat.radix.rawValue) {
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
                if let z = Int64(stack.mantisaText, radix: stack.valueFormat.radix.rawValue) {
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
                if let v = Int64(text, radix: stack.valueFormat.radix.rawValue) {
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

