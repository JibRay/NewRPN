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
                                    .font(.system(size: 20))
                                    .frame(width: key.width(), height: key.height())
                                    .background(key.color)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(10)
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
                                    .font(.system(size: 32))
                                    .frame(width: key.width(), height: key.height())
                                    .background(key.color)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(15)
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
