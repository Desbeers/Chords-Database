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
    @EnvironmentObject var model: ChordsDatabaseModel
    /// The bass chords to show in this `View`
    @State private var bassChords: [ChordDefinition] = []
    /// The body of the `View`
    var body: some View {
        VStack {
            Text("Bass")
                .font(.title)
            List(selection: $model.selection.bass) {
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
        .task(id: model.rootChords) {
            filterBassChords()
        }
        .task(id: model.selection.quality) {
            filterBassChords()
        }
    }
    /// Filter the chords by bass note
    private func filterBassChords() {
        bassChords = model.rootChords.uniqued(by: \.bass).filter { $0.bass != nil }
        if let quality = model.selection.quality {
            bassChords = bassChords.filter { $0.quality == quality }
        }
    }
}
