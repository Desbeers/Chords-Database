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

    /// The Navigation stack path
    @Published var navigationStack: [ChordDefinition] = []

    /// Export  ``allChords`` to a `String`
    var exportDB: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let encodedData = try encoder.encode(allChords)
            let jsonString = String(
                data: encodedData,
                encoding: .utf8
            )
            return jsonString ?? "error"
        } catch {
            return "error"
        }
    }
    /// Import a database String as a [ChordDefinition] array
    func importDB(database: String) {
        do {
            if let data = database.data(using: .utf8) {
                let chords = try JSONDecoder().decode([ChordDefinition].self, from: data)
                allChords = chords.sorted { $0.root == $1.root ? $0.quality < $1.quality : $0.root < $1.root }
            }
        } catch {
            print(error)
        }
    }
}
