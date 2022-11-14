//
//  ContentView.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftyChords

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
            KeyDetailsView()
                .navigationSplitViewColumnWidth(200)
        }, detail: {
            DatabaseView()
        })
        .animation(.default, value: midiFilter)
        .toolbar {
            
            /// Test button
            Button(action: {
                ChordUtilities.QualityManager.shared.loadQualities()
                let chord = ChordUtilities.Chord(chord: "A11")
                dump(chord.components())
//                dump(ChordUtilities.findChordsFromNotes(notes: ["A", "E", "C#"]))
//                dump(ChordUtilities.findChordsFromNotes(notes: ["A", "C#", "E"]))
//                dump(ChordUtilities.findChordsFromNotes(notes: ["A", "C", "E"]))
            }, label: {
                Text("Test")
            })
            
            MidiPlayer.InstrumentPicker()

            /// New Chord Button
            Button(action: {
                let newChord = ChordPosition(id: UUID(),
                                             frets: [0, 0, 0, 0, 0, 0],
                                             fingers: [0, 0, 0, 0, 0, 0],
                                             baseFret: 1,
                                             barres: [],
                                             midi: [48, 52, 55, 60, 64],
                                             key: model.selectedKey,
                                             suffix: model.selectedSuffix ?? .major
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
