//
//  ContentView.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// The  Main View
struct MainView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// Visibility for the NavigationSpliView
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    /// Filter MIDI toggle
    @AppStorage("Bad MIDI filter") private var midiFilter = false
    /// MIDI instrument
    @AppStorage("MIDI instrument") private var midiInstrument: MidiPlayer.Instrument = .acousticNylonGuitar
    /// The body of the View
    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            sidebar: {
            SidebarView()
                    .navigationSplitViewColumnWidth(StaticSetting.sidebarColumnWidth)
                    .navigationBarBackButtonHidden()
                    .navigationTitle("Chords")
        }, content: {
            RootDetailsView()
                .navigationSplitViewColumnWidth(200)
                .navigationBarBackButtonHidden()
                .navigationTitle("Suffix")
        }, detail: {
            DatabaseView()
                .navigationBarBackButtonHidden()
                .navigationTitle("Database")
        })
        .navigationTitle("Chords Database")
        .animation(.default, value: midiFilter)
        .toolbar {
            MidiPlayer.InstrumentPicker()
            /// New Chord Button
            Button(action: {
                let newChord = ChordPosition(id: UUID(),
                                             frets: [0, 0, 0, 0, 0, 0],
                                             fingers: [0, 0, 0, 0, 0, 0],
                                             baseFret: 1,
                                             barres: [],
                                             midi: [48, 52, 55, 60, 64],
                                             key: model.selectedRoot ?? .c,
                                             suffix: model.selectedQuality ?? .major
                )
                model.editChord = newChord
            }, label: {
                Label("New Chord", systemImage: "plus")
            })
            .labelStyle(.iconOnly)
        }
#if os(macOS)
        .sheet(item: $model.editChord) { chord in
            ChordEditView(chord: chord)
                .frame(minWidth: 740, minHeight: 700)
        }
#else
        .fullScreenCover(item: $model.editChord) { chord in
            ChordEditView(chord: chord)
        }
#endif
    }
}
