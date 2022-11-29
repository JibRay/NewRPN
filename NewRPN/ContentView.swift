//
//  ContentView.swift
//  NewRPN
//
//  Created by Jib Ray on 11/28/22.
//

import SwiftUI

enum Buttons: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "/"
    case multiply = "X"
    case enter = "ENTER"
    case clear = "DEL"
    case decimal = "."
    case exponent = "EEX"
    case negate = "+/-"
    
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide:
            return Color(.orange)
        case .clear, .negate, .exponent, .enter:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

struct ContentView: View {
    @State var value = "0"
    
    let buttons: [[Buttons]] = [
        [.enter, .negate, .exponent],
        [.seven, .eight, .nine, .divide],
        [.four, .five, .six, .multiply],
        [.one, .two, .three, .subtract],
        [.zero, .decimal, .clear, .add]
    ]
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                // Stack display.
                HStack {
                    Spacer()
                    Text(value)
                        .bold()
                        .font(.system(size: 52))
                        .foregroundColor(.white)
                }
                .padding()
                
                // Keypad display.
                ForEach(buttons, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { key in
                            Button(action: {
                                
                            }, label: {
                                Text(key.rawValue)
                                    .font(.system(size: 32))
                                    .frame(width: self.keyWidth(key: key), height: self.keyHeight())
                                    .background(key.buttonColor)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(20)
                            })
                        }
                    }
                }
            }
        }
    }
    func didTap(key: Buttons) {}
    
    func keyWidth(key: Buttons) -> CGFloat {
        return 70
    }
    
    func keyHeight() -> CGFloat {
        return 70
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
