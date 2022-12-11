//
//  BaseStackKeypad.swift
//  NewRPN
//
//  Created by Jib Ray on 12/6/22.
//

import SwiftUI

struct BaseStackKeypad: Keypad {
    @Binding var stack: Stack
    let fontSize: CGFloat = 20

    // This keypad's operations.
    let operationMap = ["OVER": KeyStroke(operation: .over),
                        "SWAP": KeyStroke(operation: .swap),
                        "PICK": KeyStroke(operation: .pick),
                        "DROP": KeyStroke(operation: .drop)]

    // Buttons displayed by this keypad.
    let key: [[Key]] = [
        [Key((1,4), symbol: "OVER", color: Color.AppColor.stack),
         Key((1,4), symbol: "SWAP", color: Color.AppColor.stack),
         Key((1,4), symbol: "PICK", color: Color.AppColor.stack),
         Key((1,4), symbol: "DROP", color: Color.AppColor.stack)]
    ]
    
    func parse(_ keySymbol: String) -> Bool {
        if stack.parse(keySymbol) {
            return true
        }
        if let operationToken = operationMap[keySymbol] {
            switch operationToken.operation {
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

