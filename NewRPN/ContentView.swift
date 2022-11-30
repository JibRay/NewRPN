//
//  ContentView.swift
//  NewRPN
//
//  Created by Jib Ray on 11/28/22.
//

import SwiftUI

struct ContentView: View {
    @State var value = "0"
    
    let baseEngineeringKeypad = BaseEngineeringKeypad()
    let mainKeypad = MainKeypad()
    
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
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                .padding()
                
                // Keypads display.
                KeypadView(keypad: baseEngineeringKeypad)
                KeypadView(keypad: mainKeypad)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
