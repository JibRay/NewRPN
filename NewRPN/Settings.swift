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
    
    var body: some View {
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
