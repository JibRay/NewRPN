//
//  Style.swift
//  NewRPN
//
//  Created by Jib Ray on 12/11/22.
//

import SwiftUI

extension Color {
    struct AppColor {
        static var science: Color { return Color(red: 0.313, green: 0.281, blue: 0.539)}
        static var stack: Color { return Color(red: 0.253, green: 0.480, blue: 0.222)}
        static var enter: Color { return Color(red: 0.429, green: 0.429, blue: 0.429)}
        static var numbers: Color { return Color(red: 0.469, green: 0.320, blue: 0.234)}
        static var operators: Color { return Color(red: 0.60, green: 0.352, blue: 0.0)}
        static var message: Color { Color.white }
        static var error: Color { Color.pink }
    }
}

// FIXME: Do the same for fonts. Take in to account screen size?
