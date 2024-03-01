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
@Observable
class ChordsDatabaseModel {
    /// All chords in the current database
    var allChords: [ChordDefinition] = []
    /// All chords filtered by root
    var rootChords: [ChordDefinition] = []
    /// All chords filtered by root and quality
    var qualityChords: [ChordDefinition] = []
    /// The selction of root, quality and bass
    var selection = Selection()
    /// Edit a chord
    var editChord: ChordDefinition?
    /// The *update document* toggle
    /// - Note: Toggled when a chord is new or changed
    var updateDocument: Bool = false
    /// The current instrument
    var instrument: Instrument = .guitarStandardETuning
    /// Template toggle
    var showTemplate: Bool = false
    /// The Navigation stack path
    var navigationStack: [ChordDefinition] = []
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
