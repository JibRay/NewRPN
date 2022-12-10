//
//  ContentView.swift
//  NewRPN
//
//  Created by Jib Ray on 11/28/22.
//

import SwiftUI

struct ContentView: View {
    @State var stack = Stack()
    
    var body: some View {
        NavigationView {
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
                    KeypadView(stack: $stack, keypad: BaseEngineeringKeypad(stack: $stack))
                    KeypadView(stack: $stack, keypad: BaseStackKeypad(stack: $stack))
                    KeypadView(stack: $stack, keypad: IntegerKeypad(stack: $stack))
                }
            }
            .toolbar {
                Button(action: {
                    
                }, label: {
                    Label("Options", systemImage: "gear")
                        .foregroundColor(Color.white)
//                    Image(systemName: "gear")
//                        .foregroundColor(Color.white)
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
