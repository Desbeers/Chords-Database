//
//  MainView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` containing the main content
struct MainView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// Chord Display Options
    @EnvironmentObject private var options: ChordDisplayOptions
    /// The body of the `View`
    var body: some View {
        NavigationSplitView(
            sidebar: {
                HStack(spacing: 0) {
                    RootPickerView()
                    Divider()
                    QualityPickerView()
                }
                .navigationSplitViewColumnWidth(240)
                .navigationBarBackButtonHidden()
            }, detail: {
                NavigationStack(path: $model.navigationStack) {
                    DatabaseView()
#if !os(macOS)
                        .navigationBarBackButtonHidden()
#endif
                }
            }
        )
        .navigationTitle("Chords Database")
        .toolbar {
            Text(model.instrument.label)
            // ExportButton()
            options.mirrorToggle
            options.midiInstrumentPicker
            /// New Chord Button
            Button(action: {
                if let newChord = ChordDefinition(definition: "C", instrument: model.instrument) {
                    options.definition = newChord
                    model.navigationStack.append(newChord)
                }
            }, label: {
                Label("New Chord", systemImage: "plus")
            })
            .disabled(!model.navigationStack.isEmpty)
            .labelStyle(.iconOnly)
        }
    }
}
