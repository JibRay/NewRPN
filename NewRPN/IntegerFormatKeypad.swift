//
//  IntegerFormatKeypad.swift
//  NewRPN
//
//  Created by Jib Ray on 12/19/22.
//

import SwiftUI

struct IntegerFormatKeypad: Keypad  {
    @Binding var stack: Stack
    let fontSize: CGFloat = 18

    // This keypad's operations.
    let operationMap = ["o:": KeyStroke(operation: .selectOctal),
                        "d:": KeyStroke(operation: .selectDecimal),
                        "h:": KeyStroke(operation: .selectHexadecimal),
                        "arrow.counterclockwise": KeyStroke(operation: .switchRadix),
                        "SIZE": KeyStroke(operation: .size)]

    // Buttons displayed by this keypad.
    let key: [[Key]] = [
        [Key((1,5), symbol: "o:", color: Color.AppColor.enter),
         Key((1,5), symbol: "d:", color: Color.AppColor.enter),
         Key((1,5), symbol: "h:", color: Color.AppColor.enter),
         Key((1,5), icon: .systemSymbol, symbol: "arrow.counterclockwise", color: Color.AppColor.enter),
         Key((1,5), symbol: "SIZE", color: Color.AppColor.enter)]
    ]
    
    func parse(_ keySymbol: String) -> Bool {
        if stack.parse(keySymbol) {
            return true // If stack handled it, we're done.
        }
        if let operationToken = operationMap[keySymbol] {
            switch operationToken.operation {
            case .selectOctal:
                stack.valueFormat.radix = .octal
                stack.valueFormat.format = .standard
                stack.entryValuePrefix = "o:"
            case .selectDecimal:
                stack.valueFormat.radix = .decimal
                stack.valueFormat.format = .standard
                stack.entryValuePrefix = ""
            case .selectHexadecimal:
                stack.valueFormat.radix = .hexidecimal
                stack.valueFormat.format = .standard
                stack.entryValuePrefix = "h:"
            case .switchRadix:
                stack.valueFormat.format = .standard
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
            case .size:
                if let w = Int(stack.mantisaText) {
                    if w > 1 && w <= 32 {
                        stack.valueFormat.integerWordSize = w
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
