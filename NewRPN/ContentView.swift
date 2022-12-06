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
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Spacer()
            VStack {
                Spacer()
                ForEach(0 ..< 5) { i in
                    HStack {
                        Spacer()
                        Text("\(stack.stackItemText(4 - i))")
                            .bold()
                            .font(.system(size: 32))
                            .monospaced()
                            .foregroundColor(.white)
                            .padding(.trailing, 20)
                    }
                }
                HStack {
                    Text(stack.entryValueText)
                        .bold()
                        .font(.system(size: 32))
                        .monospaced()
                        .foregroundColor(.yellow)
                    Spacer()
                }
                
                // Keypads display.
                KeypadView(stack: $stack, keypad: baseEngineeringKeypad)
                KeypadView(stack: $stack, keypad: stackKeypad)
                KeypadView(stack: $stack, keypad: DecimalKeypad(stack: $stack))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
