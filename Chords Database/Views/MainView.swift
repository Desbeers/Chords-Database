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
    @Environment(ChordsDatabaseModel.self) private var chordsDatabaseModel
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
    /// The body of the `View`
    var body: some View {
        @Bindable var chordsDatabaseModel = chordsDatabaseModel
        NavigationSplitView(
            sidebar: {
                HStack(spacing: 0) {
                    RootPickerView()
                    Divider()
                    QualityPickerView()
                    Divider()
                    BassPickerView()
                }
                .navigationSplitViewColumnWidth(260)
                .navigationBarBackButtonHidden()
            }, detail: {
                NavigationStack(path: $chordsDatabaseModel.navigationStack) {
                    DatabaseView()
#if !os(macOS)
                        .navigationBarBackButtonHidden()
#endif
                }
            }
        )
        .navigationTitle("Chords Database")
        .toolbar {
            Text(chordsDatabaseModel.instrument.label)
            chordDisplayOptions.mirrorToggle
            chordDisplayOptions.midiInstrumentPicker
            /// New Chord Button
            Button(action: {
                if let newChord = ChordDefinition(
                    definition: "C",
                    instrument: chordsDatabaseModel.instrument,
                    status: .standard
                ) {
                    chordDisplayOptions.definition = newChord
                    chordsDatabaseModel.navigationStack.append(newChord)
                }
            }, label: {
                Label("New Chord", systemImage: "plus")
            })
            .disabled(!chordsDatabaseModel.navigationStack.isEmpty)
            .labelStyle(.iconOnly)
        }
    }
}
