//
//  LogicKeypad.swift
//  NewRPN
//
//  Created by Jib Ray on 12/14/22.
//

import SwiftUI

struct LogicKeypad: Keypad {
    @Binding var stack: Stack
    let fontSize: CGFloat = 18
    
    // This keypad's operations.
    let operationMap = ["AND": KeyStroke(operation: .and),
                        "OR": KeyStroke(operation: .or),
                        "NOT": KeyStroke(operation: .not),
                        "XOR": KeyStroke(operation: .xor),
                        "<-": KeyStroke(operation: .leftShift),
                        "->": KeyStroke(operation: .rightShift)]
    
    // Buttons displayed by this keypad.
    let key: [[Key]] = [
        [Key((1,6), symbol: "AND", color: Color.AppColor.science),
         Key((1,6), symbol:  "OR", color: Color.AppColor.science),
         Key((1,6), symbol: "NOT", color: Color.AppColor.science),
         Key((1,6), symbol: "XOR", color: Color.AppColor.science),
         Key((1,6), symbol: "<-", color: Color.AppColor.science),
         Key((1,6), symbol: "->", color: Color.AppColor.science)]
    ]

    func parse(_ keySymbol: String) -> Bool {
        if stack.parse(keySymbol) {
            return true
        }
        if let operationToken = operationMap[keySymbol] {
            switch operationToken.operation {
            case .and:
                if let x = Int64(stack.mantisaText, radix: stack.radix.rawValue) {
                        stack.stackItems[0].integerValue &= x
                } else {
                    if let y: Int64 = stack.pop()?.integerValue {
                        stack.stackItems[0].integerValue &= y
                    }
                }
                stack.clearMantisa()
            case .or:
                if let x = Int64(stack.mantisaText, radix: stack.radix.rawValue) {
                        stack.stackItems[0].integerValue |= x
                } else {
                    if let y: Int64 = stack.pop()?.integerValue {
                        stack.stackItems[0].integerValue |= y
                    }
                }
                stack.clearMantisa()
            case .not:
                if stack.stackDepth() > 0 {
                    stack.stackItems[0].integerValue = ~stack.stackItems[0].integerValue
                }
                stack.clearMantisa()
            case .xor:
                if let x = Int64(stack.mantisaText, radix: stack.radix.rawValue) {
                    stack.stackItems[0].integerValue ^= x
                } else {
                    if let y: Int64 = stack.pop()?.integerValue {
                        stack.stackItems[0].integerValue ^= y
                    }
                }
                stack.clearMantisa()
            case .leftShift:
                if let n = Int(stack.mantisaText, radix: stack.radix.rawValue) {
                    if stack.stackDepth() > 0 {
                        let x: Int64 = stack.stackItems[0].integerValue
                        stack.stackItems[0].integerValue = x << n
                    }
                }
                stack.clearMantisa()
            case .rightShift:
                if let n = Int(stack.mantisaText, radix: stack.radix.rawValue) {
                    if stack.stackDepth() > 0 {
                        let x: Int64 = stack.stackItems[0].integerValue
                        stack.stackItems[0].integerValue = x >> n
                    }
                }
                stack.clearMantisa()
            default:
                stack.clearMantisa()
            }
        }
        return true
    }
}
