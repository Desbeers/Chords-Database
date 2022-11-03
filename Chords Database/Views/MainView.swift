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
            /// Filter MIDI toggle
            Toggle("Hide good MIDI", isOn: $midiFilter)
            /// New Chord Button
            Button(action: {
                do {
                    let newChord = try ChordPosition(id: UUID(),
                                                     frets: [0, 0, 0, 0, 0, 0],
                                                     fingers: [0, 0, 0, 0, 0, 0],
                                                     baseFret: 1,
                                                     barres: [],
                                                     midi: [48, 52, 55, 60, 64],
                                                     key: .c,
                                                     suffix: .major
                    )
                    model.editChord = newChord
                } catch {
                    /// ignore
                }
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
