//
//  BassPickerView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

struct BassPickerView: View {
    /// The SwiftUI model for the Chords Database
    @Environment(ChordsDatabaseModel.self) private var chordsDatabaseModel
    /// The bass chords to show in this `View`
    @State private var bassChords: [ChordDefinition] = []
    /// The body of the `View`
    var body: some View {
        @Bindable var chordsDatabaseModel = chordsDatabaseModel
        VStack {
            Text("Bass")
                .font(.title)
            List(selection: $chordsDatabaseModel.selection.bass) {
                ForEach(bassChords) { chord in
                    if let bass = chord.bass {
                        Text("/\(bass.display.symbol)")
                            .font(.title3)
                            .tag(bass)
                    }
                }
            }
        }
        .frame(width: 80)
        .task(id: chordsDatabaseModel.rootChords) {
            filterBassChords()
        }
        .task(id: chordsDatabaseModel.selection.quality) {
            filterBassChords()
        }
    }
    /// Filter the chords by bass note
    private func filterBassChords() {
        bassChords = chordsDatabaseModel.rootChords.uniqued(by: \.bass).filter { $0.bass != nil }
        if let quality = chordsDatabaseModel.selection.quality {
            bassChords = bassChords.filter { $0.quality == quality }
        }
    }
}
