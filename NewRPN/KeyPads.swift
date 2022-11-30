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

struct MainKeypad: Keypad {
    let fontSize: CGFloat = 32
    
    let key: [[Key]] = [
        [Key((5,4), symbol: "ENTER", columns: 2, color: Color(.gray)),
         Key((5,4), symbol: "+/-", color: Color(.gray)),
         Key((5,4), symbol: "EEX", color: Color(.gray))],
        
        [Key((5,4), symbol: "7", color: Color(.brown)),
         Key((5,4), symbol: "8", color: Color(.brown)),
         Key((5,4), symbol: "9", color: Color(.brown)),
         Key((5,4), symbol: "/", color: Color(.orange))],
        
        [Key((5,4), symbol: "4", color: Color(.brown)),
         Key((5,4), symbol: "5", color: Color(.brown)),
         Key((5,4), symbol: "6", color: Color(.brown)),
         Key((5,4), symbol: "X", color: Color(.orange))],
        
        [Key((5,4), symbol: "1", color: Color(.brown)),
         Key((5,4), symbol: "2", color: Color(.brown)),
         Key((5,4), symbol: "3", color: Color(.brown)),
         Key((5,4), symbol: "-", color: Color(.orange))],
        
        [Key((5,4), symbol: "0", color: Color(.brown)),
         Key((5,4), symbol: ".", color: Color(.brown)),
         Key((5,4), symbol: "DEL", color: Color(.gray)),
         Key((5,4), symbol: "+", color: Color(.orange))]
    ]
}

struct BaseEngineeringKeypad: Keypad {
    let fontSize: CGFloat = 20
    
    let key: [[Key]] = [
        [Key((2,6), symbol: "SIN", color: Color(.blue)),
         Key((2,6), symbol: "COS", color: Color(.blue)),
         Key((2,6), symbol: "TAN", color: Color(.blue)),
         Key((2,6), symbol: "SQR", color: Color(.blue)),
         Key((2,6), symbol: "yX", color: Color(.blue)),
         Key((2,6), symbol: "1/X", color: Color(.blue))],
        
        [Key((2,6), symbol: "ASIN", color: Color(.blue)),
         Key((2,6), symbol: "ACOS", color: Color(.blue)),
         Key((2,6), symbol: "ATAN", color: Color(.blue)),
         Key((2,6), symbol: "x2", color: Color(.blue)),
         Key((2,6), symbol: "10X", color: Color(.blue)),
         Key((2,6), symbol: "eX", color: Color(.blue))]
    ]
}
