//
//  ContentView.swift
//  NewRPN
//
//  Created by Jib Ray on 11/28/22.
//

import SwiftUI

enum EntryKeys {
    case decimal, integer
}

enum ScienceKeys {
    case baseEngineering, logic
}

struct ContentView: View {
    @State var stack = Stack()
    @State private var isShowingSettings = false
    @State private var entryKeys: EntryKeys = .decimal
    @State private var scienceKeys: ScienceKeys = .baseEngineering
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                Spacer()
                VStack {
                    Spacer()
                    ForEach(0..<4) { i in
                        HStack {
                            Spacer()
                            Text("\(stack.stackItemText(3 - i))")
                                .bold()
                                .font(.system(size: 25))
                                .monospaced()
                                .foregroundColor(.white)
                                .padding(.trailing, 20)
                        }
                    }
                    HStack {
                        Text(stack.entryValueText)
                            .bold()
                            .font(.system(size: 25))
                            .monospaced()
                            .foregroundColor(.yellow)
                        Spacer()
                    }
                    
                    // Keypads display.
                    switch scienceKeys {
                    case .baseEngineering:
                        KeypadView(stack: $stack, keypad: BaseEngineeringKeypad(stack: $stack))
                    case .logic:
                        KeypadView(stack: $stack, keypad: LogicKeypad(stack: $stack))
                    }
                    KeypadView(stack: $stack, keypad: BaseStackKeypad(stack: $stack))
                    switch entryKeys {
                    case .decimal:
                        KeypadView(stack: $stack, keypad: DecimalKeypad(stack: $stack))
                    case .integer:
                        KeypadView(stack: $stack, keypad: IntegerKeypad(stack: $stack))
                    }
                }
            }
            .toolbar {
                Button(action: {
                    isShowingSettings.toggle()
                }, label: {
                    Image(systemName: "gear")
                        .foregroundColor(Color.white)
                })
                .sheet(isPresented: $isShowingSettings, onDismiss: didDismissSettings) {
                    VStack {
                        HStack {
                            Text("Entry:")
                            Button("Decimal",
                                   action: {
                                entryKeys = .decimal
                                scienceKeys = .baseEngineering
                            })
                            Button("Integer",
                                   action: {
                                entryKeys = .integer
                                scienceKeys = .logic
                            })
                        }
                        Spacer()
                        Button("Close",
                               action: {isShowingSettings.toggle()})
                    }
                }
            }
        }
    }
    func didDismissSettings() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
