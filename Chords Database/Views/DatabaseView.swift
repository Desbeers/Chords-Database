//
//  DatabaseView.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftyChords
import SwiftlyChordUtilities

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
    /// Bool if we have chords or not
    @State var haveChords = true
    /// The selection in the table
    @State private var selection: ChordPosition.ID?
    /// The chord for the 'delete' action
    @State private var actionButton: ChordPosition?
    /// The body of the View
    var body: some View {
        if !haveChords && chords.isEmpty {
            Text("No chords in the key of \(model.selectedRoot.display.symbol) found in the datadase")
                .font(.title)
                .padding(.top)
        }
        Table(chords, selection: $selection) {
            TableColumn("Diagram") { chord in
                model.diagram(chord: chord)
                    .background(Color(nsColor: .textBackgroundColor))
                    .cornerRadius(4)
            }
            .width(120)
            TableColumn("Chord") { chord in
                VStack(alignment: .leading) {
                    Text("\(chord.key.display.accessible)\(chord.suffix.display.accessible)")
                        .font(.title2)
                    chordFinder(chord: chord)
                }
            }
            TableColumn("Base Fret") { chord in
                Text("\(chord.baseFret)")
            }
            .width(80)
            TableColumn("Midi") { chord in
                VStack(alignment: .leading) {
                    MidiPlayer.PlayButton(chord: chord)
                    Text(chord.midi == Midi.values(values: chord) ? "" : "MIDI values are not correct")
                        .font(.caption)
                        .padding(.top)
                }
            }
            .width(140)
            TableColumn("Action") { chord in
                actions(chord: chord)
            }
        }
        .buttonStyle(.bordered)
        .animation(.default, value: haveChords)
        .id(model.selectedRoot)
        .task(id: model.allChords) {
            filterChords()
        }
        .task(id: model.selectedRoot) {
            filterChords()
        }
        .task(id: model.selectedQuality) {
            filterChords()
        }
        .task(id: midiFilter) {
            filterChords()
        }
    }

    func filterChords() {
        var allChords = model.allChords.filter({$0.key == model.selectedRoot})
        if let suffix = model.selectedQuality {
            allChords = allChords.filter({$0.suffix == suffix})
        }
        if midiFilter {
            allChords = allChords.filter({$0.midi != Midi.values(values: $0)})
        }
        allChords.sort(using: KeyPathComparator(\.key))
        allChords.sort(using: KeyPathComparator(\.suffix))
        allChords.sort(using: KeyPathComparator(\.baseFret))
        chords = allChords
        haveChords = chords.isEmpty ? false : true
    }
    
    func chordFinder(chord: ChordPosition) -> some View {
        VStack(alignment: .leading) {
            Label(chord.chordFinder.isEmpty ? "Found no matching chord" : "Found:", systemImage: "waveform.and.magnifyingglass")
                .padding(.vertical, 3)
            HStack {
                //Text(chord.chordFinder.isEmpty ? "Found nothing" : "Found")
                ForEach(chord.chordFinder) { result in
                    Text(result.display)
                        .foregroundColor(chord.name == result.name ? .accentColor : .secondary)
                }
            }
            .font(.title3)
        }
    }
    
    func actions(chord: ChordPosition) -> some View {
        VStack(alignment: .leading) {
            editButton(chord: chord)
            duplicateButton(chord: chord)
            Button(action: {
                actionButton = chord
                confirmationShown = true
            }, label: {
                Label("Delete", systemImage: "trash")
            })
        }
        .labelStyle(ActionLabelStyle())
        .confirmationDialog(
            "Delete \(actionButton?.key.display.accessible ?? "") \(actionButton?.suffix.display.accessible ?? "")?",
            isPresented: $confirmationShown,
            titleVisibility: .visible
        ) {
            deleteButton(chord: actionButton)
        } message: {
            Text("With base fret \(actionButton?.baseFret ?? 1000)")
        }
    }

    func editButton(chord: ChordPosition) -> some View {
        Button(action: {
            model.editChord = chord
        }, label: {
            Label("Edit Chord", systemImage: "square.and.pencil")
        })
    }

    func deleteButton(chord: ChordPosition?) -> some View {
        Button(action: {
            if let chord, let chordIndex = model.allChords.firstIndex(where: {$0.id == chord.id}) {
                model.allChords.remove(at: chordIndex)
                model.updateDocument.toggle()
            }
        }, label: {
            Text("Delete")
        })
    }

    func duplicateButton(chord: ChordPosition) -> some View {
        Button(action: {
            let newChord = ChordPosition(id: UUID(),
                                         frets: chord.frets,
                                         fingers: chord.fingers,
                                         baseFret: chord.baseFret,
                                         barres: chord.barres,
                                         midi: chord.midi,
                                         key: chord.key,
                                         suffix: chord.suffix
            )
            model.editChord = newChord
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
