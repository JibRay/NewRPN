//
//  DecimalFormatKeypad.swift
//  NewRPN
//
//  Created by Jib Ray on 12/19/22.
//

import SwiftUI

struct DecimalFormatKeypad: Keypad  {
    @Binding var stack: Stack
    let fontSize: CGFloat = 18
    
    // This keypad's operations.
    let operationMap = ["STD": KeyStroke(operation: .std),
                        "FIX": KeyStroke(operation: .fix),
                        "SCI": KeyStroke(operation: .sci),
                        "ENG": KeyStroke(operation: .eng)]

    // Buttons displayed by this keypad.
    let key: [[Key]] = [
        [Key((5,4), symbol: "STD", color: Color.AppColor.enter),
         Key((5,4), symbol: "FIX", color: Color.AppColor.enter),
         Key((5,4), symbol: "SCI", color: Color.AppColor.enter),
         Key((5,4), symbol: "ENG", color: Color.AppColor.enter)]
        ]
    
    func setFormat(_ format: Format) {
        if format == .standard {
            stack.valueFormat.format = format
        } else {
            if let x = stack.getEntryValue() {
                let n = Int(x)
                if n >= 0 && n <= 10 {
                    stack.valueFormat.format = format
                    stack.valueFormat.decimalPlaces = n
                } else {
                    stack.message = "Error: argument out of range"
                }
            } else {
                stack.message = "Error: missing argument"
            }
        }
    }
    
    func parse(_ keySymbol: String) -> Bool {
        stack.valueFormat.radix = .decimal
        if stack.parse(keySymbol) {
            return true
        }
        if let operationToken = operationMap[keySymbol] {
            switch operationToken.operation {
            case .std:
                setFormat(.standard)
            case .fix:
                setFormat(.fixed)
            case .sci:
                setFormat(.science)
            case .eng:
                setFormat(.engineering)
            default:
                stack.clearMantisa()
            }
        }
        return true
    }
}
