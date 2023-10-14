//
//  RootPickerView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` containing the root picker in the sidebar
struct RootPickerView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// The Keys to show in this View
    @State var kays: [Chord.Root] = []
    /// The body of the `View`
    var body: some View {
        VStack {
            Text("Root")
                .font(.title)
            List(selection: $model.selection.root) {
                ForEach(Chord.Root.allCases, id: \.rawValue) { key in
                    Text(key.display.symbol)
                        .font(.title3)
                        .tag(key)
                }
            }
        }
        .frame(width: 80)
        .task(id: model.allChords) {
            filterChords()
        }
        .task(id: model.selection.root) {
            filterSelection()
        }
    }
    private func filterChords() {
        if model.selection.root == Chord.Root.none {
            model.rootChords = model.allChords
        } else {
            model.rootChords = model.allChords.filter { $0.root == model.selection.root }
        }
    }
    private func filterSelection() {
        filterChords()
        model.selection.quality = nil
        model.selection.bass = nil
    }
}
