//
//  BaseEngineeringKeypad.swift
//  NewRPN
//
//  Created by Jib Ray on 12/6/22.
//

import SwiftUI

struct BaseEngineeringKeypad: Keypad {
    @Binding var stack: Stack
    let fontSize: CGFloat = 18
    
    // This keypad's operations.
    let operationMap = [" ": KeyStroke(operation: .none),
                        "_": KeyStroke(operation: .none),
                        "\u{03C0}": KeyStroke(operation: .pi),
                        "X\\Y": KeyStroke(operation: .xRootY),
                        "LOG": KeyStroke(operation: .log),
                        "LN": KeyStroke(operation: .ln),
                        "SIN": KeyStroke(operation: .sin),
                        "COS": KeyStroke(operation: .cos),
                        "TAN": KeyStroke(operation: .tan),
                        "x.squareroot": KeyStroke(operation: .sqrt),
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
        [Key((3,6), symbol: " ", color: Color.AppColor.science),
         Key((3,6), symbol:  "_", color: Color.AppColor.science),
         Key((3,6), symbol: "\u{03C0}", color: Color.AppColor.science),
         Key((3,6), symbol: "X\\Y", color: Color.AppColor.science),
         Key((3,6), symbol: "LOG", color: Color.AppColor.science),
         Key((3,6), symbol: "LN", color: Color.AppColor.science)],
        [Key((3,6), symbol: "SIN", color: Color.AppColor.science),
         Key((3,6), symbol: "COS", color: Color.AppColor.science),
         Key((3,6), symbol: "TAN", color: Color.AppColor.science),
         Key((3,6), icon: true, symbol: "x.squareroot", color: Color.AppColor.science),
         Key((3,6), symbol: "yX", color: Color.AppColor.science),
         Key((3,6), symbol: "1/x", color: Color.AppColor.science)],
        
        [Key((3,6), symbol: "ASIN", color: Color.AppColor.science),
         Key((3,6), symbol: "ACOS", color: Color.AppColor.science),
         Key((3,6), symbol: "ATAN", color: Color.AppColor.science),
         Key((3,6), symbol: "x2", color: Color.AppColor.science),
         Key((3,6), symbol: "10X", color: Color.AppColor.science),
         Key((3,6), symbol: "eX", color: Color.AppColor.science)]
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
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.push(StackItem(decimalValue: asin(x)))
                }
            case .acos:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.push(StackItem(decimalValue: acos(x)))
                }
            case .atan:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.push(StackItem(decimalValue: atan(x)))
                }
            case .Xsquared:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.push(StackItem(decimalValue: x * x))
                }
            case .tenToX:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.push(StackItem(decimalValue: pow(10.0, x)))
                }
            case .eToX:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.push(StackItem(decimalValue: exp(x)))
                }
            case .pi:
                stack.push(StackItem(decimalValue: Double.pi))
            case .log:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.push(StackItem(decimalValue: log10(x)))
                }
            case .ln:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.push(StackItem(decimalValue: log(x)))
                }
            default:
                stack.clearMantisa()
            }
            return true
        }
        return false
    }
}
