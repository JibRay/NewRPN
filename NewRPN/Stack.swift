//
//  Stack.swift
//  NewRPN
//
//  Created by Jib Ray on 11/30/22.
//

import SwiftUI

struct Stack {
    let stackSize = 4
    // Top of the stack is [0] and bottom is [stackSize - 1].
    var stackItems = [StackItem](repeating: StackItem(), count: 4)
    var storedItems = [StackItem](repeating: StackItem(), count: 10)
    var message: String = "Version \(NewRPNApp.version)"
    var messageForegroundColor: Color = Color.white
    var entryValuePrefix: String = ""
    var entryValueText: String {
        get {
            var text: String
            if (parsingMantisa) {
                text = negateNumberString(mantisaText, negative: negateMantisa)
            } else {
                text = negateNumberString(mantisaText, negative: negateMantisa)
                    + "e" + negateNumberString(exponentText, negative: negateExponent)
            }
            if text.count > 0 {
                return entryValuePrefix + text
            }
            return text
        }
    }
    
    var valueFormat: ValueFormat = ValueFormat()
    var degrees: Bool = true
    var error: Bool = false // This seems like a messy way to do this.
    
    var mantisaText: String = ""
    var exponentText: String = ""
    var parsingMantisa = true
    var negateMantisa = false
    var negateExponent = false
    let validOctalNumbers = "01234567"
    let validDecimalNumbers = "0123456789.:"
    let validHexNumbers = "0123456789ABCDEF"
    let operationMap = ["+/-": KeyStroke(operation: .negate),
                        "DEL": KeyStroke(operation: .delete),
                        "EEX": KeyStroke(operation: .exponent),
                        "+": KeyStroke(operation: .add),
                        "-": KeyStroke(operation: .subtract),
                        "x": KeyStroke(operation: .multiply),
                        "/": KeyStroke(operation: .divide),
                        "ENTER": KeyStroke(operation: .enter),
                        "OVER": KeyStroke(operation: .over),
                        "SWAP": KeyStroke(operation: .swap),
                        "PICK": KeyStroke(operation: .pick),
                        "DROP": KeyStroke(operation: .drop)]

    mutating func getEntryValue() -> Double? {
        var value: Double? = nil
        var text = ""
        if mantisaText.count > 0 {
            if mantisaText.contains(":") {
                value = fromHMS(mantisaText)
                if (value == nil) {
                    postError("Error: invalid format")
                }
            } else {
                text = { negateMantisa ? "-" : "" }() + mantisaText
                if exponentText.count > 0 {
                    text += "e" + { negateExponent ? "-" : "" }() + exponentText
                }
                if let v = Double(text) {
                    value = v
                }
            }
            clearMantisa()
        }
        return value
    }

    mutating func getEntryOrStackValue() -> Double? {
        var value: Double? = nil
        if let v = getEntryValue() {
            if !error {
                value = v
            }
        } else if !error {
            value = pop()?.decimalValue
        }
        return value
    }
    
    // If negative is true prepend a "-" number.
    func negateNumberString(_ number: String, negative: Bool) -> String {
        if negative {
            return "-" + number
        } else {
            return number
        }
    }
    
    mutating func clearMantisa() {
        mantisaText = ""
        exponentText = ""
        negateMantisa = false
        negateExponent = false
        parsingMantisa = true
    }
    
    // Convert time spec in text to hours. Format of text
    // is expected to be hh:mm:s.s. Return nil if conversion
    // fails.
    func fromHMS(_ text: String) -> Double? {
        var t: Double? = nil
        let parts = text.components(separatedBy: ":")
        if parts.count == 3 {
            if let hours = Int(parts[0]) {
                if let minutes = Int(parts[1]) {
                    if let seconds = Int(parts[2]) {
                        t = Double(hours)
                        t! += Double(minutes) / 60.0
                        t! += Double(seconds) / 3600.0
                    }
                }
            }
        }
        return t
    }

    mutating func postMessage(_ text: String) {
        message = text
        messageForegroundColor = Color.AppColor.message
    }
    
    mutating func postError(_ text: String) {
        message = text
        messageForegroundColor = Color.AppColor.error
        error = true;
    }
    
    var stackDepth: Int {
        var depth = 0
        for index in 0..<stackSize {
            if stackItems[index].empty {
                return depth
            } else {
                depth += 1
            }
        }
        return depth
    }
    
    // If value is valid, push it. Otherwise post and error.
    mutating func pushDecimalValue(_ value: Double) {
        if value.isFinite {
            push(StackItem(decimalValue: value))
        } else {
            postError("invalid number")
        }
    }
    
    mutating func push(_ item: StackItem) {
        for index in stride(from: stackSize - 1, through: 1, by: -1) {
            stackItems[index] = stackItems[index - 1]
        }
        stackItems[0] = item
    }
    
    mutating func pop() -> StackItem? {
        if stackDepth > 0 {
            let top = stackItems[0]
            for index in 1..<stackSize {
                stackItems[index - 1] = stackItems[index]
            }
            stackItems[stackSize - 1].empty = true
            return top
        }
        return nil
    }
    
    mutating func over() {
        if !stackItems[1].empty {
            push(stackItems[1])
        }
    }
    
    mutating func swap() {
        if !stackItems[0].empty && !stackItems[1].empty {
            let top = stackItems[0]
            stackItems[0] = stackItems[1]
            stackItems[1] = top
        }
    }
    
    mutating func pick(_ item: Int) {
        if item < stackSize && !stackItems[item].empty {
            push(stackItems[item])
        }
    }
    
    mutating func drop() {
        _ = pop()
    }
    
    // If keySymbol is a valid number in the current radix,
    // process it and return true. Otherwise return false.
    mutating func parse(_ keySymbol: String) -> Bool {
        message = ""
        error = false
        switch valueFormat.radix {
        case .octal:
            if (validOctalNumbers.contains(keySymbol)) {
                if mantisaText.count < 15 {
                    mantisaText += keySymbol
                }
                return true
            }
        case .hexidecimal:
            if (validHexNumbers.contains(keySymbol)) {
                if mantisaText.count < 15 {
                    mantisaText += keySymbol
                }
                return true
            }
        case .decimal:
            if (validDecimalNumbers.contains(keySymbol)) {
                if parsingMantisa {
                    if mantisaText.count < 15 {
                        mantisaText += keySymbol
                    }
                } else {
                    if exponentText.count < 3 && keySymbol != "." {
                        exponentText += keySymbol
                    }
                }
                return true
            }
        }
        return false
    }
}
