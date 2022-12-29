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
    let operationMap = ["->H:M:S": KeyStroke(operation: .toHMS),
                        "SINH": KeyStroke(operation: .sinh),
                        "COSH": KeyStroke(operation: .cosh),
                        "TANH": KeyStroke(operation: .tanh),
                        ":": KeyStroke(operation: .none),
                        "H:M:S->": KeyStroke(operation: .fromHMS),
                        "\u{03C0}": KeyStroke(operation: .pi),
                        "x.root.y": KeyStroke(operation: .xRootY),
                        "LOG": KeyStroke(operation: .log),
                        "LN": KeyStroke(operation: .ln),
                        "SIN": KeyStroke(operation: .sin),
                        "COS": KeyStroke(operation: .cos),
                        "TAN": KeyStroke(operation: .tan),
                        "x.squareroot": KeyStroke(operation: .sqrt),
                        "y.to.x": KeyStroke(operation: .YtoX),
                        "1/x": KeyStroke(operation: .invertX),
                        "ASIN": KeyStroke(operation: .asin),
                        "ACOS": KeyStroke(operation: .acos),
                        "ATAN": KeyStroke(operation: .atan),
                        "2.to.x": KeyStroke(operation: .Xsquared),
                        "10.to.x": KeyStroke(operation: .tenToX),
                        "e.to.x": KeyStroke(operation: .eToX)]
    
    // Buttons displayed by this keypad.
    let key: [[Key]] = [
        [Key((3,6), symbol: "->H:M:S", columns: 2, color: Color.AppColor.science),
         Key((3,6), symbol: "H:M:S->", columns: 2, color: Color.AppColor.science),
         Key((3,6), symbol: ":", color: Color.AppColor.science),
         Key((3,6), symbol: "\u{03C0}", color: Color.AppColor.science)],
        
        [Key((3,6), symbol: "SINH", color: Color.AppColor.science),
         Key((3,6), symbol: "COSH", color: Color.AppColor.science),
         Key((3,6), symbol: "TANH", color: Color.AppColor.science),
         Key((3,6), icon: .image, symbol: "x.root.y", color: Color.AppColor.science),
         Key((3,6), symbol: "LOG", color: Color.AppColor.science),
         Key((3,6), symbol: "LN", color: Color.AppColor.science)],
        
        [Key((3,6), symbol: "SIN", color: Color.AppColor.science),
         Key((3,6), symbol: "COS", color: Color.AppColor.science),
         Key((3,6), symbol: "TAN", color: Color.AppColor.science),
         Key((3,6), icon: .systemSymbol, symbol: "x.squareroot", color: Color.AppColor.science),
         Key((3,6), icon: .image, symbol: "y.to.x", color: Color.AppColor.science),
         Key((3,6), symbol: "1/x", color: Color.AppColor.science)],
        
        [Key((3,6), symbol: "ASIN", color: Color.AppColor.science),
         Key((3,6), symbol: "ACOS", color: Color.AppColor.science),
         Key((3,6), symbol: "ATAN", color: Color.AppColor.science),
         Key((3,6), icon: .image, symbol: "2.to.x", color: Color.AppColor.science),
         Key((3,6), icon: .image, symbol: "10.to.x", color: Color.AppColor.science),
         Key((3,6), icon: .image, symbol: "e.to.x", color: Color.AppColor.science)]
    ]

    func parse(_ keySymbol: String) -> Bool {
        if stack.parse(keySymbol) {
            return true
        }
        if let operationToken = operationMap[keySymbol] {
            switch operationToken.operation {
            case .toHMS:
                if stack.stackDepth() > 0 {
                    stack.valueFormat.displayAsHMS = true
                }
            case .fromHMS:
                if stack.stackDepth() > 0 {
                    stack.valueFormat.displayAsHMS = false
                }
            case .sin:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(sin(x))
                }
            case .cos:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(cos(x))
                }
            case .tan:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(tan(x))
                }
            case .sqrt:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(sqrt(x))
                }
            case .YtoX:
                if let x: Double = stack.getEntryOrStackValue() {
                    if stack.stackDepth() > 0 {
                        let ys = stack.pop()
                        let y = ys!.decimalValue
                        stack.pushDecimalValue(pow(y, x))
                    }
                }
            case .invertX:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(1.0 / x)
                }
            case .asin:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(asin(x))
                }
            case .acos:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(acos(x))
                }
            case .atan:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(atan(x))
                }
            case .Xsquared:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(x * x)
                }
            case .tenToX:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(pow(10.0, x))
                }
            case .eToX:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(exp(x))
                }
            case .pi:
                stack.push(StackItem(decimalValue: Double.pi))
            case .log:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(log10(x))
                }
            case .ln:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(log(x))
                }
            case .sinh:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(sinh(x))
                }
            case .cosh:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(cosh(x))
                }
            case .tanh:
                if let x: Double = stack.getEntryOrStackValue() {
                    stack.pushDecimalValue(tanh(x))
                }
            case .xRootY:
                if let x: Double = stack.getEntryOrStackValue() {
                    if stack.stackDepth() > 0 {
                        let ys = stack.pop()
                        let y = ys!.decimalValue
                        stack.pushDecimalValue(pow(y, 1.0 / x))
                    }
                }
            default:
                stack.clearMantisa()
            }
            return true
        }
        return false
    }
}
