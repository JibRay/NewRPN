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

enum FormatKeys {
    case decimal, integer
}

// The main calculator view. Displays keys, stack and toolbar.
struct ContentView: View {
    @State var stack = Stack()
    @State var isShowingSettings = false
    @State var entryKeys: EntryKeys = .decimal
    @State var scienceKeys: ScienceKeys = .baseEngineering
    @State var formatKeys: FormatKeys = .decimal
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        NavigationView {
            // Base ZStack is required to keep background black when dragging
            // the ZStack above it.
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                // This ZStack provides black background and is
                // dragged to switch between keypad sets.
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    Spacer()
                    VStack {
                        Spacer()
                        // Display all the stack items, right justified.
                        ForEach(0..<4) { i in
                            HStack {
                                Spacer()
                                Text("\(stack.stackItems[3 - i].text(format: stack.valueFormat))")
                                    .font(.system(size: 25))
                                    .monospaced()
                                    .foregroundColor(.white)
                                    .padding(.trailing, 20)
                            }
                        }
                        HStack {
                            // Display the entry line, left justified.
                            Text(stack.entryValueText)
                                .font(.system(size: 25))
                                .monospaced()
                                .foregroundColor(.yellow)
                            Spacer()
                        }
                        
                        // Display science keys.
                        switch scienceKeys {
                        case .baseEngineering:
                            KeypadView(stack: $stack, keypad: BaseEngineeringKeypad(stack: $stack))
                        case .logic:
                            KeypadView(stack: $stack, keypad: LogicKeypad(stack: $stack))
                        }
                        KeypadView(stack: $stack, keypad: BaseStackKeypad(stack: $stack))
                        
                        // Display format keys.
                        switch formatKeys {
                        case .decimal:
                            KeypadView(stack: $stack, keypad: DecimalFormatKeypad(stack: $stack))
                        case .integer:
                            KeypadView(stack: $stack, keypad: IntegerFormatKeypad(stack: $stack))
                        }
                        
                        // Display entry keys.
                        switch entryKeys {
                        case .decimal:
                            KeypadView(stack: $stack, keypad: DecimalKeypad(stack: $stack))
                        case .integer:
                            KeypadView(stack: $stack, keypad: IntegerKeypad(stack: $stack))
                        }
                    }
                }
                .offset(dragAmount)
                .gesture(
                    DragGesture(minimumDistance: 80)
                        .onChanged { dragAmount = $0.translation }
                        .onEnded {_ in
                            dragAmount = .zero
                            // Toggle between the decimal and integer keys.
                            if entryKeys == .decimal {
                                entryKeys = .integer
                                scienceKeys = .logic
                                formatKeys = .integer
                            } else {
                                entryKeys = .decimal
                                scienceKeys = .baseEngineering
                                formatKeys = .decimal
                                stack.valueFormat.format = .standard
                            }
                        })
                .animation(.spring(), value: dragAmount)
                // Toolbar appears at the top of the ZStack.
                .toolbar {
                    HStack() {
                        Text(stack.message)
                            .foregroundColor(stack.messageForegroundColor)
                        Spacer()
                        Button(action: {
                            stack.degrees.toggle()
                        }, label: {
                            if stack.degrees {
                                Text("Degrees")
                                    .foregroundColor(Color.white)
                            } else {
                                Text("Radians")
                                    .foregroundColor(Color.white)
                            }
                        })
                        // The settings button. This toggles the modal sheet
                        // containing the settings view.
                        Button(action: {
                            isShowingSettings.toggle()
                        }, label: {
                            Image(systemName: "gear")
                                .foregroundColor(Color.white)
                        })
                    }
                    .sheet(isPresented: $isShowingSettings, onDismiss: didDismissSettings) {
                        SettingsView(stack: $stack, entryKeys: $entryKeys,
                                     scienceKeys: $scienceKeys,
                                     formatKeys: $formatKeys,
                                     isShowingSettings: $isShowingSettings)
                    }
                }
            }
        }
    }
    // FIXME: Not used, can probably be deleted.
    func didDismissSettings() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
