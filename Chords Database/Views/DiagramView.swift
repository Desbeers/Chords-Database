//
//  DiagramView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

struct DiagramView: View {
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
}
