//
//  KeyPads.swift
//  NewRPN
//
//  Created by Jib Ray on 11/29/22.
//

import SwiftUI

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
    var key: [[Key]] { get }
    var fontSize: CGFloat { get }
}

struct KeypadView: View {
    @Binding var stack: Stack
    
    let keypad: any Keypad
    
    var body: some View {
        ForEach(keypad.key, id: \.self) { row in
            HStack {
                ForEach(row, id: \.self) { key in
                    Button(action: {
                        stack.parse(key.symbol)
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

struct StackKeypad: Keypad {
    let fontSize: CGFloat = 20
    
    let key: [[Key]] = [
        [Key((1,4), symbol: "OVER", color: Color(.gray)),
         Key((1,4), symbol: "SWAP", color: Color(.gray)),
         Key((1,4), symbol: "PICK", color: Color(.gray)),
         Key((1,4), symbol: "DROP", color: Color(.gray))]
    ]

}

struct BaseEngineeringKeypad: Keypad {
    let fontSize: CGFloat = 20
    
    let key: [[Key]] = [
        [Key((2,6), symbol: "SIN", color: Color(.blue)),
         Key((2,6), symbol: "COS", color: Color(.blue)),
         Key((2,6), symbol: "TAN", color: Color(.blue)),
         // Key((2,6), symbol: "\(Image(systemName: "x.squareroot"))", color: Color(.blue)),
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
}
