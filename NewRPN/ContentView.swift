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
                ForEach(baseEngineeringKeypad.key, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { key in
                            Button(action: {
                                
                            }, label: {
                                Text(key.symbol)
                                    .font(.system(size: baseEngineeringKeypad.fontSize))
                                    .frame(width: key.width(), height: key.height())
                                    .background(key.color)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(0.3 * baseEngineeringKeypad.fontSize)
                            })
                        }
                    }
                }
                ForEach(mainKeypad.key, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { key in
                            Button(action: {
                                
                            }, label: {
                                Text(key.symbol)
                                    .font(.system(size: mainKeypad.fontSize))
                                    .frame(width: key.width(), height: key.height())
                                    .background(key.color)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(0.3 * mainKeypad.fontSize)
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
