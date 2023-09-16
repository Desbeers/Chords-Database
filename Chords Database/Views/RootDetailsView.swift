//
//  RootDetailsView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// The  Details View for a selected `key`
struct RootDetailsView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// The Suffixes to show in this View
    @State var suffixes: [ChordDefinition] = []
    /// Filter MIDI toggle
    @AppStorage("Bad MIDI filter") private var midiFilter = false
    /// The body of the View
    var body: some View {
        List(selection: $model.selectedQuality) {
            ForEach(suffixes) { suffix in
                HStack {
                    Text("\(suffix.root.rawValue)")
                        .font(.headline)
                    Text("\(suffix.quality.display.symbolized)")
                }
                    .tag(suffix.quality)
            }
        }
        .task(id: model.allChords) {
            filterSuffixes()
        }
        .task(id: model.selectedRoot) {
            filterSuffixes()
        }
        .task(id: midiFilter) {
            filterSuffixes()
        }
    }

    func filterSuffixes() {
        let allSuffixes = model.allChords.matching(root: model.selectedRoot ?? .c)
        suffixes = allSuffixes.uniqued(by: \.quality)
    }
}
