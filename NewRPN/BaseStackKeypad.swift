//
//  BaseStackKeypad.swift
//  NewRPN
//
//  Created by Jib Ray on 12/6/22.
//

import SwiftUI

struct BaseStackKeypad: Keypad {
    @Binding var stack: Stack
    let fontSize: CGFloat = 18

    // This keypad's operations.
    let operationMap = ["STO": KeyStroke(operation: .sto),
                        "RCL": KeyStroke(operation: .rcl),
                        "OVER": KeyStroke(operation: .over),
                        "SWAP": KeyStroke(operation: .swap),
                        "PICK": KeyStroke(operation: .pick),
                        "DROP": KeyStroke(operation: .drop)]

    // Buttons displayed by this keypad.
    let key: [[Key]] = [
        [Key((1,6), symbol: "STO", color: Color.AppColor.stack),
         Key((1,6), symbol: "RCL", color: Color.AppColor.stack),
         Key((1,6), symbol: "OVER", color: Color.AppColor.stack),
         Key((1,6), symbol: "SWAP", color: Color.AppColor.stack),
         Key((1,6), symbol: "PICK", color: Color.AppColor.stack),
         Key((1,6), symbol: "DROP", color: Color.AppColor.stack)]
    ]
    
    func parse(_ keySymbol: String) -> Bool {
        if stack.parse(keySymbol) {
            return true
        }
        if let operationToken = operationMap[keySymbol] {
            switch operationToken.operation {
            case .sto:
                if let x = stack.getEntryValue() {
                    let i = Int(x)
                    if i >= 0 && i <= 9 {
                        if stack.stackDepth > 0 {
                            stack.storedItems[i] = stack.pop()!
                        } else {
                            stack.postError("Stack empty")
                        }
                    } else {
                        stack.postError("Index out of range")
                    }
                } else {
                    stack.postError("Missing index")
                }
                stack.clearMantisa()
            case .rcl:
                if let x = stack.getEntryValue() {
                    let i = Int(x)
                    if i >= 0 && i <= 9 {
                        stack.push(stack.storedItems[i])
                    } else {
                        stack.postError("Index out of range")
                    }
                } else {
                    stack.postError("Missing index")
                }
                stack.clearMantisa()
            case .over:
                stack.over()
                stack.clearMantisa()
            case .swap:
                stack.swap()
            case .pick:
                if let n = Int(stack.mantisaText) {
                    stack.pick(n - 1)
                }
                stack.clearMantisa()
            case .drop:
                stack.drop()
            default:
                stack.clearMantisa()
            }
            return true
        }
        return false
    }
}

