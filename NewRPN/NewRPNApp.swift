//
//  NewRPNApp.swift
//  NewRPN
//
//  Created by Jib Ray on 11/28/22.
//

import SwiftUI

// TODO:
// 1. Add color option to message. Maybe a message type with an
// associated color.
// 2. Post message when format changes.
// 3. Finish H:M:S.
// 4. Implement STO and RCL.
// 5. Keep working on error checking.
@main
struct NewRPNApp: App {
    let version: Int = 2
    var body: some Scene {
        WindowGroup {
            ContentView(version: self.version)
        }
    }
}
