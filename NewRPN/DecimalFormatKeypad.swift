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

    func parse(_ keySymbol: String) -> Bool {
        stack.radix = .decimal
        if stack.parse(keySymbol) {
            return true
        }
        return true
    }
}
