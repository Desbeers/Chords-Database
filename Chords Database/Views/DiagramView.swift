//
//  DiagramView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` to show a chord diagram
struct DiagramView: View {
    /// The chord definition
    let chord: ChordDefinition
    /// The width of the diagram
    let width: Double
    /// Chord Display Options
    @EnvironmentObject private var options: ChordDisplayOptions
    /// The current color scheme
    @Environment(\.colorScheme) private var colorScheme
    /// The body of the `View`
    var body: some View {
        ChordDefinitionView(chord: chord, width: width, options: options.displayOptions)
            .frame(height: width * 1.6)
            .foregroundStyle(Color.primary, colorScheme == .dark ? .black : .white)
            .animation(.default, value: options.displayOptions)
            .animation(.default, value: options.definition)
    }
}
