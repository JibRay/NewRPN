//
//  KeyPads.swift
//  NewRPN
//
//  Created by Jib Ray on 11/29/22.
//

import SwiftUI

enum KeyType {
    case number, operation
}

enum KeyOperation {
    case none, delete, negate, exponent, add, subtract, multiply, divide, enter
    case selectOctal, selectDecimal, selectHexadecimal, switchRadix
    case over, swap, pick, drop
    case sin, cos, tan, sqrt, YtoX, invertX
    case asin, acos, atan, Xsquared, tenToX, eToX
}

struct KeyStroke {
    var type: KeyType = .number
    var value: Character = "0"
    var operation: KeyOperation = .none
    
    init(value: Character) {
        self.value = value
        type = .number
    }
    
    init(operation: KeyOperation) {
        self.operation = operation
        type = .operation
    }
}

struct Key: Hashable {
    var geometry: (Int, Int) // The geometry of the keypad that contains
                             // this key: (rowCount, columnCount)
    var symbol: String
    var rows: Int = 1      // Number of rows this key occupies.
    var columns: Int = 1   // Number of columns this key occupies.
    var color: Color
    
    
    init(_ geometry: (Int, Int), symbol: String, rows: Int = 1, columns: Int = 1, color: Color) {
        self.geometry = geometry
        self.symbol = symbol
        self.rows = rows
        self.columns = columns
        self.color = color
    }
    static func == (lhs: Key, rhs: Key) -> Bool {
        return lhs.symbol == rhs.symbol
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
    }
    
    // columnCount is the number of columns in the row where this key
    // resides.
    // Return the key width.
    func width() -> CGFloat {
        let cc: CGFloat = CGFloat(geometry.1)
        let n: CGFloat = CGFloat(columns)
        let w = n * ((UIScreen.main.bounds.width - (((cc - 1) * 10) + 20)) / cc)
        return w
    }
    
    // rowCount is the number of rows in the column where this key resides.
    // Return the key height.
    func height() -> CGFloat {
        return 50
    }
}

protocol Keypad {
    var stack: Stack { get set }
    var key: [[Key]] { get }
    var fontSize: CGFloat { get }
    func parse(_ keySymbol: String) -> Bool
}

struct KeypadView: View {
    @Binding var stack: Stack
    
    var keypad: any Keypad
    
    var body: some View {
        ForEach(keypad.key, id: \.self) { row in
            HStack {
                ForEach(row, id: \.self) { key in
                    Button(action: {
                        _ = keypad.parse(key.symbol)
                    }, label: {
                        Text(key.symbol)
                            .font(.system(size: keypad.fontSize))
                            .frame(width: key.width(), height: key.height())
                            .background(key.color)
                            .foregroundColor(Color.white)
                            .cornerRadius(0.3 * keypad.fontSize)
                    })
                }
            }
        }
    }
}

