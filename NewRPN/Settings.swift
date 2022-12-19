//
//  Settings.swift
//  NewRPN
//
//  Created by Jib Ray on 12/15/22.
//

import SwiftUI

struct SettingsView: View {
    @Binding var stack: Stack
    @Binding var entryKeys: EntryKeys
    @Binding var scienceKeys: ScienceKeys
    @Binding var isShowingSettings: Bool
    
    func decimalKeypadSymbol() -> String {
        if (entryKeys == .decimal) {
            return "checkmark.circle"
        } else {
            return "circle"
        }
    }
    
    func integerKeypadSymbol() -> String {
        if (entryKeys == .integer) {
            return "checkmark.circle"
        } else {
            return "circle"
        }
    }
    
    var body: some View {
        ZStack {
            Color.gray
            VStack(alignment: .leading) {
                HStack() {
                    Button(action: {isShowingSettings.toggle()}, label: {
                        Image(systemName: "arrow.left")
                    })
                    .font(.title)
                    .foregroundColor(Color.black)
                    Spacer()
                }
                Button(action: {
                    entryKeys = .decimal
                    scienceKeys = .baseEngineering
                    stack.radix = .decimal
                }) {
                    Label("Decimal Kepad", systemImage: decimalKeypadSymbol())
                }
                .font(.title)
                .foregroundColor(Color.black)
                .padding(.leading, 30)
                Button(action: {
                    entryKeys = .integer
                    scienceKeys = .logic
                }) {
                    Label("Integer Kepad", systemImage: integerKeypadSymbol())
                }
                .font(.title)
                .foregroundColor(Color.black)
                .padding(.leading, 30)
                Spacer()
            }
        }
    }
}
