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
    @Environment(ChordsDatabaseModel.self) private var chordsDatabaseModel
    /// The Keys to show in this View
    @State var kays: [Chord.Root] = []
    /// The body of the `View`
    var body: some View {
        @Bindable var chordsDatabaseModel = chordsDatabaseModel
        VStack {
            Text("Root")
                .font(.title)
            List(selection: $chordsDatabaseModel.selection.root) {
                ForEach(Chord.Root.allCases, id: \.rawValue) { key in
                    Text(key.display.symbol)
                        .font(.title3)
                        .tag(key)
                }
            }
        }
        .frame(width: 80)
        .task(id: chordsDatabaseModel.allChords) {
            filterChords()
        }
        .task(id: chordsDatabaseModel.selection.root) {
            filterSelection()
        }
    }
    private func filterChords() {
        if chordsDatabaseModel.selection.root == Chord.Root.none {
            chordsDatabaseModel.rootChords = chordsDatabaseModel.allChords
        } else {
            chordsDatabaseModel.rootChords = chordsDatabaseModel
                .allChords
                .filter { $0.root == chordsDatabaseModel.selection.root }
        }
    }
    private func filterSelection() {
        filterChords()
        chordsDatabaseModel.selection.quality = nil
        chordsDatabaseModel.selection.bass = nil
    }
}
