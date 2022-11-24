//
//  ChordsDatabaseModel.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftyChords

// MARK: The Chord Databse model

/// The SwiftUI model for the Chords Database
class ChordsDatabaseModel: ObservableObject {
    /// All chords in the current database
    @Published var allChords: [ChordPosition] = []
    /// The selected root in the ``SidebarView``
    @Published var selectedRoot: Chords.Root = .c
    /// The selected Suffix in the ``RootDetailsView``
    @Published var selectedQuality: Chords.Quality?
    /// Edit a chord
    @Published var editChord: ChordPosition?
    /// The *update document* toggle
    /// - Note: Toggled when a chord is new or changed
    @Published var updateDocument: Bool = false
    /// Export  ``allChords`` to a `String`
    var exportDB: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let encodedData = try encoder.encode(allChords)
            let jsonString = String(data: encodedData,
                                    encoding: .utf8)
            return jsonString ?? "error"
        } catch {
            return "error"
        }
    }
    /// Import a database String as a [ChordPosition] array
    func importDB(database: String) {
        do {
            if let data = database.data(using: .utf8) {
                let chords = try JSONDecoder().decode([ChordPosition].self,
                                                      from: data)
                allChords = chords.sorted { $0.key == $1.key ? $0.suffix < $1.suffix : $0.key < $1.key }
            }
        } catch {
            print("error")
        }
    }
    static func getChords() -> [ChordPosition] {
        SwiftyChords.Chords.guitar
            .sorted { $0.key == $1.key ? $0.suffix < $1.suffix : $0.key < $1.key }
    }
    /// Build a SwiftUI Image diagram fom a `ChordPosition`
    @ViewBuilder func diagram(chord: ChordPosition, frame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 150)) -> some View {
        let layer = chord.chordLayer(rect: frame, showFingers: true, chordName: .init(show: true, key: .symbol, suffix: .symbolized))
        if let image = layer.image() {
#if os(macOS)
            Image(nsImage: image)
#endif
#if os(iOS)
            Image(uiImage: image)
#endif
        } else {
            Image(systemName: "music.note")
        }
    }
}
