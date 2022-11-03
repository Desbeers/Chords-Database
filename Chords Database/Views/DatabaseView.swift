//
//  DatabaseView.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftyChords

/// The  Database View for Chords
struct DatabaseView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// Filter MIDI toggle
    @AppStorage("Bad MIDI filter") private var midiFilter = false
    /// The conformation dialog to delete a chord
    @State private var confirmationShown = false
    /// The Chords to show in this View
    @State var chords: [SwiftyChords.ChordPosition] = []
    /// The body of the View
    var body: some View {
        Table(chords) {
            TableColumn("Diagram") { chord in
                model.diagram(chord: chord)
            }
            TableColumn("Chord") { chord in
                Text(chord.key.display.symbol + chord.suffix.display.symbolized)
            }
            TableColumn("Full") { chord in
                Text(chord.key.display.accessible + chord.suffix.display.accessible)
            }
            TableColumn("Base fret") { chord in
                Text(chord.baseFret.description)
            }
            TableColumn("Midi") { chord in
                Text(chord.midi == Midi.values(values: chord) ? "Correct" : "Wrong")
                    .font(.headline)
            }
            TableColumn("Action") { chord in
                VStack {
                    editButton(chord: chord)
                    duplicateButton(chord: chord)
                    Button(action: {
                        confirmationShown = true
                    }, label: {
                        Text("Delete")
                    })
                    .confirmationDialog(
                        "Delete \(chord.key.display.accessible + chord.suffix.display.accessible)?",
                        isPresented: $confirmationShown,
                        titleVisibility: .visible
                    ) {
                        deleteButton(chord: chord)
                    } message: {
                        model.diagram(chord: chord)
                        Text("With base fret \(chord.baseFret)")
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .id(model.selectedKey)
        .task(id: model.allChords) {
            filterChords()
        }
        .task(id: model.selectedKey) {
            filterChords()
        }
        .task(id: model.selectedSuffix) {
            filterChords()
        }
        .task(id: midiFilter) {
            filterChords()
        }
    }
    
    func filterChords() {
        var allChords = model.allChords.filter({$0.key == model.selectedKey})
        if let suffix = model.selectedSuffix {
            allChords = allChords.filter({$0.suffix == suffix})
        }
        
        if midiFilter {
            allChords = allChords.filter({$0.midi != Midi.values(values: $0)})
        }
        
        chords = allChords
    }

    func editButton(chord: ChordPosition) -> some View {
        Button(action: {
            model.editChord = chord
        }, label: {
            Text("Edit")
        })
    }
    
    func deleteButton(chord: ChordPosition) -> some View {
        Button(action: {
            if let chordIndex = model.allChords.firstIndex(where: {$0.id == chord.id}) {
                model.allChords.remove(at: chordIndex)
                model.updateDocument.toggle()
            }
        }, label: {
            Text("Delete")
        })
    }
    
    func duplicateButton(chord: ChordPosition) -> some View {
        Button(action: {
            do {
            let newChord = try ChordPosition(id: UUID(),
                                             frets: chord.frets,
                                             fingers: chord.fingers,
                                             baseFret: chord.baseFret,
                                             barres: chord.barres,
                                             midi: chord.midi,
                                             key: chord.key,
                                             suffix: chord.suffix
                                         )
                model.editChord = newChord
            } catch {
                /// ignore
            }
        }, label: {
            Text("Duplicate")
        })
    }
}
