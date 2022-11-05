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
    /// MIDI instrument
    @AppStorage("MIDI instrument") private var midiInstrument: MidiPlayer.Instrument = .acousticNylonGuitar
    /// The conformation dialog to delete a chord
    @State private var confirmationShown = false
    /// The Chords to show in this View
    @State var chords: [ChordPosition] = []
    /// The body of the View
    var body: some View {
        Table(chords) {
            TableColumn("Diagram") { chord in
                model.diagram(chord: chord)
            }
            TableColumn("Chord") { chord in
                Text("\(chord.key.display.accessible)\(chord.suffix.display.accessible)")
            }
            TableColumn("Base Fret") { chord in
                Text("\(chord.baseFret)")
            }
            TableColumn("Midi") { chord in
                VStack(alignment: .leading) {
                    MidiPlayer.PlayButton(chord: chord)
                    Text(chord.midi == Midi.values(values: chord) ? "MIDI values are correct" : "MIDI values are wrong")
                        .font(.caption)
                        .padding(.top)
                }
            }
            TableColumn("Action") { chord in
                actions(chord: chord)
            }
        }
        .buttonStyle(.bordered)
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
        allChords.sort(using: KeyPathComparator(\.key))
        allChords.sort(using: KeyPathComparator(\.suffix))
        allChords.sort(using: KeyPathComparator(\.baseFret))
        chords = allChords
    }

    func actions(chord: ChordPosition) -> some View {
        VStack(alignment: .leading) {
            editButton(chord: chord)
            duplicateButton(chord: chord)
            Button(action: {
                confirmationShown = true
            }, label: {
                Label("Delete", systemImage: "trash")
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
        .labelStyle(ActionLabelStyle())
    }

    func editButton(chord: ChordPosition) -> some View {
        Button(action: {
            model.editChord = chord
        }, label: {
            Label("Edit Chord", systemImage: "square.and.pencil")
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
            Label("Duplicate", systemImage: "doc.on.doc")
        })
    }

    struct ActionLabelStyle: LabelStyle {
        @Environment(\.sizeCategory) var sizeCategory
        func makeBody(configuration: Configuration) -> some View {
                HStack {
                    configuration.icon
                        .bold()
                        .frame(width: 16)
                    configuration.title
                        .frame(width: 70, alignment: .leading)
                }
        }
    }
}
