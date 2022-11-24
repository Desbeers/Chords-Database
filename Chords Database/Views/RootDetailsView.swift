//
//  RootDetailsView.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftyChords
import SwiftlyChordUtilities

/// The  Details View for a selected `key`
struct RootDetailsView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// The Suffixes to show in this View
    @State var suffixes: [SwiftyChords.ChordPosition] = []
    /// Filter MIDI toggle
    @AppStorage("Bad MIDI filter") private var midiFilter = false
    /// The body of the View
    var body: some View {
        List(selection: $model.selectedQuality) {
            ForEach(suffixes) { suffix in
                HStack {
                    Text("\(suffix.key.rawValue)")
                        .font(.headline)
                    Text("\(suffix.suffix.display.symbolized)")
                }
                    .tag(suffix.suffix)
            }
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
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
        var allSuffixes = model.allChords.filter({$0.key == model.selectedRoot})
        if midiFilter {
            allSuffixes = allSuffixes.filter({$0.midi != Midi.values(values: $0)})
        }
        suffixes = allSuffixes.unique { $0.suffix }
        // model.selectedQuality = .five
    }
}
