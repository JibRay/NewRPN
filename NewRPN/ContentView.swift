//
//  ContentView.swift
//  NewRPN
//
//  Created by Jib Ray on 11/28/22.
//

import SwiftUI

struct ContentView: View {
    @State var stack = Stack()
    
    let baseEngineeringKeypad = BaseEngineeringKeypad()
    let stackKeypad = StackKeypad()
    let mainKeypad = MainKeypad()
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                // Stack display.
                HStack {
                    Spacer()
                    Text(stack.entryValueText)
                        .bold()
                        .font(.system(size: 40))
                        .foregroundColor(.yellow)
                }
                .padding()
                
                // Keypads display.
                KeypadView(stack: $stack, keypad: baseEngineeringKeypad)
                KeypadView(stack: $stack, keypad: stackKeypad)
                KeypadView(stack: $stack, keypad: mainKeypad)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
