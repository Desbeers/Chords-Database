//
//  ChordsDatabaseModel.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

// MARK: The Chord Databse model

/// The SwiftUI model for the Chords Database
class ChordsDatabaseModel: ObservableObject {
    /// All chords in the current database
    @Published var allChords: [ChordDefinition] = []
    /// The selected root in the ``SidebarView``
    @Published var selectedRoot: Chord.Root? = .c
    /// The selected Suffix in the ``RootDetailsView``
    @Published var selectedQuality: Chord.Quality?
    /// Edit a chord
    @Published var editChord: ChordDefinition?
    /// The *update document* toggle
    /// - Note: Toggled when a chord is new or changed
    @Published var updateDocument: Bool = false

    /// The current instrument
    @Published var instrument: Instrument = .guitarStandardETuning

    /// Template toggle
    @Published public var showTemplate: Bool = false

    /// The Navigation stack path
    @Published var navigationStack: [ChordDefinition] = []

//    /// Export  ``allChords`` to a `String`
//    var exportDB: String {
//        Chords.getChordDefinitions(database: .guitarChordDefinitions, definitions: allChords)
//    }
//    /// Import a database String as a [ChordDefinition] array
//    func importDB(database: Chords.Database, definitions: String) {
//        allChords = Chords.importChordDefinitions(database: database, definitions: definitions)
//    }
}
