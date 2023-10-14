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
    @EnvironmentObject var model: ChordsDatabaseModel
    /// The body of the `View`
    var body: some View {
        VStack {
            Text("Quality")
                .font(.title)
            List(selection: $model.selection.quality) {
                ForEach(model.qualityChords) { quality in
                    Text("\(quality.quality == .major ? "M" : quality.quality.display.symbolized)")
                        .font(.title3)
                    .tag(quality.quality)
                }
            }
        }
        .frame(width: 100)
        .task(id: model.rootChords) {
            filterQualities()
        }
        .task(id: model.selection.quality) {
            model.selection.bass = nil
        }
    }
    /// Filter the chords by quality
    private func filterQualities() {
        model.qualityChords = model.rootChords.uniqued(by: \.quality).sorted(using: KeyPathComparator(\.quality))
    }
}
