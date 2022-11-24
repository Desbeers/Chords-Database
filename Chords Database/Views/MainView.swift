//
//  ContentView.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftyChords
import SwiftlyChordUtilities

/// The  Main View
struct MainView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// Visibility for the NavigationSpliView
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
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
        }, content: {
            RootDetailsView()
                .navigationSplitViewColumnWidth(200)
        }, detail: {
            DatabaseView()
        })
        .animation(.default, value: midiFilter)
        .toolbar {
            
//            /// Test button
//            Button(action: {
//                let chord = getChordInfo(root: .a, quality: .slashE)
//                dump(chord)
//                print(chord.components())
//            }, label: {
//                Text("Test")
//            })
//            /// Filter MIDI toggle
//                         Toggle("Hide good MIDI", isOn: $midiFilter)
            
            MidiPlayer.InstrumentPicker()
            /// New Chord Button
            Button(action: {
                let newChord = ChordPosition(id: UUID(),
                                             frets: [0, 0, 0, 0, 0, 0],
                                             fingers: [0, 0, 0, 0, 0, 0],
                                             baseFret: 1,
                                             barres: [],
                                             midi: [48, 52, 55, 60, 64],
                                             key: model.selectedRoot,
                                             suffix: model.selectedQuality ?? .major
                )
                model.editChord = newChord
            }, label: {
                Label("New Chord", systemImage: "plus")
            })
            .labelStyle(.iconOnly)
        }
        .sheet(item: $model.editChord) { chord in
            ChordEditView(chord: chord)
        }
    }
}
