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
    /// The Qualities to show in this View
    @State var qualities: [ChordDefinition] = []
    /// Filter MIDI toggle
    @AppStorage("Bad MIDI filter") private var midiFilter = false
    /// The body of the `View`
    var body: some View {
        VStack {
            Text("Quality")
                .font(.title)
            List(selection: $model.selectedQuality) {
                ForEach(qualities) { quality in
                    Text("\(quality.quality == .major ? "M" : quality.quality.display.symbolized)")
                        .font(.title3)
                    .tag(quality.quality)
                }
            }
        }
        .task(id: model.allChords) {
            filterQualities()
        }
        .task(id: model.selectedRoot) {
            filterQualities()
        }
        .task(id: midiFilter) {
            filterQualities()
        }
    }

    func filterQualities() {
        var allQualities: [ChordDefinition] = []
        if model.selectedRoot == Chord.Root.none {
            allQualities = model.allChords
        } else {
            allQualities = model.allChords.matching(root: model.selectedRoot ?? .c)
        }
        qualities = allQualities.uniqued(by: \.quality).sorted(using: KeyPathComparator(\.quality))
    }
}
