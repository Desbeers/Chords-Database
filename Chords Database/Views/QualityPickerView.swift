//
//  QualityPickerView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` containing the quality picker in the sidebar
struct QualityPickerView: View {
    /// The SwiftUI model for the Chords Database
    @Environment(ChordsDatabaseModel.self) private var chordsDatabaseModel
    /// The body of the `View`
    var body: some View {
        @Bindable var chordsDatabaseModel = chordsDatabaseModel
        VStack {
            Text("Quality")
                .font(.title)
            List(selection: $chordsDatabaseModel.selection.quality) {
                ForEach(chordsDatabaseModel.qualityChords) { quality in
                    Text("\(quality.quality == .major ? "M" : quality.quality.display.symbolized)")
                        .font(.title3)
                    .tag(quality.quality)
                }
            }
        }
        .frame(width: 100)
        .task(id: chordsDatabaseModel.rootChords) {
            filterQualities()
        }
        .task(id: chordsDatabaseModel.selection.quality) {
            chordsDatabaseModel.selection.bass = nil
        }
    }
    /// Filter the chords by quality
    private func filterQualities() {
        chordsDatabaseModel.qualityChords = chordsDatabaseModel.rootChords.uniqued(by: \.quality).sorted(using: KeyPathComparator(\.quality))
    }
}
