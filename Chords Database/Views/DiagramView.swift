//
//  DiagramView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

struct DiagramView: View {
    init(chord: ChordDefinition, width: Double, tuning: Tuning = .guitarStandardETuning) {
        if tuning == .guitarStandardETuning {
            self.chord = chord
        } else {
            self.chord = Self.transposeChord(chord: chord, tuning: tuning)
        }
        self.width = width
    }
    
    let chord: ChordDefinition
    let width: Double

    /// Chord Display Options
    @EnvironmentObject private var options: ChordDisplayOptions

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ChordDefinitionView(chord: chord, width: width, options: options.displayOptions)
            .frame(height: width * 1.6)
            .foregroundStyle(Color.primary, colorScheme == .dark ? .black : .white)
            .animation(.default, value: options.displayOptions)
            .animation(.default, value: options.definition)
    }

    static func transposeChord(chord: ChordDefinition, tuning: Tuning) -> ChordDefinition {
        return ChordDefinition(
            id: chord.id,
            name: chord.name,
            frets: chord.frets,
            fingers: chord.fingers,
            baseFret: chord.baseFret,
            root: chord.root,
            quality: chord.quality,
            tuning: tuning,
            status: chord.status
        )
    }
}
