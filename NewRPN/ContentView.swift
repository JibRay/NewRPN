//
//  ContentView.swift
//  NewRPN
//
//  Created by Jib Ray on 11/28/22.
//

import SwiftUI

struct ContentView: View {
    @State var value = "0"
    
    let mainKeypad = MainKeyPad()
    
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
                ForEach(mainKeypad.key, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { key in
                            Button(action: {
                                
                            }, label: {
                                Text(key.symbol)
                                    .font(.system(size: 32))
                                    .frame(width: key.width(), height: key.height())
                                    .background(key.color)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(20)
                            })
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
