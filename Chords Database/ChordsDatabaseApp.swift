//
//  ChordsDatabaseApp.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// The `Chords Database` App Scene
@main struct ChordsDatabaseApp: App {
    static let defaults = ChordDefinition.DisplayOptions(
        showName: true,
        showNotes: true,
        showPlayButton: true,
        rootDisplay: .symbol,
        qualityDisplay: .symbolized,
        showFingers: true,
        mirrorDiagram: false
    )
    /// Chord Display Options
    @StateObject private var options = ChordDisplayOptions(defaults: defaults)
    /// The body of the Scene
    var body: some Scene {
        DocumentGroup(newDocument: ChordsDatabaseDocument()) { file in
            ContentView(document: file.$document)
                .environmentObject(options)
        }
    }
}
