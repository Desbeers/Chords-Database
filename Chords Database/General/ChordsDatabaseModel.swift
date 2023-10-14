//
//  ChordsDatabaseModel.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

// MARK: The Chord Database model

/// The SwiftUI model for the Chords Database
class ChordsDatabaseModel: ObservableObject {
    /// All chords in the current database
    @Published var allChords: [ChordDefinition] = []
    /// All chords filtered by root
    @Published var rootChords: [ChordDefinition] = []
    /// All chords filtered by root and quality
    @Published var qualityChords: [ChordDefinition] = []
    /// The selction of root, quality and bass
    @Published var selection = Selection()
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
}

extension ChordsDatabaseModel {

    /// Structure for selection
    struct Selection: Equatable, Hashable {
        /// The selected root in the ``RootPickerView``
        var root: Chord.Root? = .c
        /// The selected Suffix in the ``QualityPickerView``
        var quality: Chord.Quality?
        /// The selected bass in the ``BassPickerView``
        var bass: Chord.Root?
    }
}
