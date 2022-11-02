//
//  ChordsDatabaseApp.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI

@main

struct ChordsDatabaseApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ChordsDatabaseDocument()) { file in
            ContentView(document: file.$document)
            
        }
    }
}
