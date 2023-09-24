//
//  RootPickerView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// The  Root Picker View
struct RootPickerView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// The Keys to show in this View
    @State var kays: [Chord.Root] = []
    /// The body of the View
    var body: some View {
        VStack {
            Text("Root")
                .font(.title)
            List(selection: $model.selectedRoot) {
                ForEach(Chord.Root.allCases, id: \.rawValue) { key in
                    Text(key.display.symbol)
                        .font(.headline)
                        .tag(key)
                }
            }
        }
        .onChange(of: model.selectedRoot) { _ in
            model.selectedQuality = nil
        }
    }
}
