//
//  ChordsDatabaseApp.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The `Chords Database` App Scene
@main struct ChordsDatabaseApp: App {
    /// The body of the Scene
    var body: some Scene {
        DocumentGroup(newDocument: ChordsDatabaseDocument()) { file in
            ContentView(document: file.$document)
            
        }
    }
}
