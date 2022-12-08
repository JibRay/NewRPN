//
//  BaseEngineeringKeypad.swift
//  NewRPN
//
//  Created by Jib Ray on 12/6/22.
//

import SwiftUI

struct BaseEngineeringKeypad: Keypad {
    @Binding var stack: Stack
    let fontSize: CGFloat = 20
    
    // This keypad's operations.
    let operationMap = ["SIN": KeyStroke(operation: .sin),
                        "COS": KeyStroke(operation: .cos),
                        "TAN": KeyStroke(operation: .tan),
                        "SQRT": KeyStroke(operation: .sqrt),
                        "yX": KeyStroke(operation: .YtoX),
                        "1/x": KeyStroke(operation: .invertX),
                        "ASIN": KeyStroke(operation: .asin),
                        "ACOS": KeyStroke(operation: .acos),
                        "ATAN": KeyStroke(operation: .atan),
                        "x2": KeyStroke(operation: .Xsquared),
                        "10X": KeyStroke(operation: .tenToX),
                        "eX": KeyStroke(operation: .eToX)]
    
    // Buttons displayed by this keypad.
    let key: [[Key]] = [
        [Key((2,6), symbol: "SIN", color: Color(.blue)),
         Key((2,6), symbol: "COS", color: Color(.blue)),
         Key((2,6), symbol: "TAN", color: Color(.blue)),
         // FIXME: Key((2,6), symbol: "\(Image(systemName: "x.squareroot"))", color: Color(.blue)),
         Key((2,6), symbol: "SQRT", color: Color(.blue)),
         Key((2,6), symbol: "yX", color: Color(.blue)),
         Key((2,6), symbol: "1/x", color: Color(.blue))],
        
        [Key((2,6), symbol: "ASIN", color: Color(.blue)),
         Key((2,6), symbol: "ACOS", color: Color(.blue)),
         Key((2,6), symbol: "ATAN", color: Color(.blue)),
         Key((2,6), symbol: "x2", color: Color(.blue)),
         Key((2,6), symbol: "10X", color: Color(.blue)),
         Key((2,6), symbol: "eX", color: Color(.blue))]
    ]

    func parse(_ keySymbol: String) -> Bool {
        if stack.parse(keySymbol) {
            return true
        }
        if let operationToken = operationMap[keySymbol] {
            switch operationToken.operation {
            case .sin:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.push(StackItem(decimalValue: sin(x)))
                }
            case .cos:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.push(StackItem(decimalValue: cos(x)))
                }
            case .tan:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.push(StackItem(decimalValue: tan(x)))
                }
            case .sqrt:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.push(StackItem(decimalValue: sqrt(x)))
                }
            case .YtoX:
                if let x: Double = stack.getEntryOrStackValue() {
                    if stack.stackDepth() > 0 {
                        let ys = stack.pop()
                        let y = ys!.decimalValue
                        stack.push(StackItem(decimalValue: pow(y, x)))
                    }
                }
            case .invertX:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.push(StackItem(decimalValue: 1.0 / x))
                }
            case .asin:
                _ = 0
            case .acos:
                _ = 0
            case .atan:
                _ = 0
            case .Xsquared:
                _ = 0
            case .tenToX:
                _ = 0
            case .eToX:
                _ = 0
            default:
                stack.clearMantisa()
            }
            return true
        }
        return false
    }
}
