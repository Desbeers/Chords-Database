//
//  ChordEditView.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftyChords
import SwiftlyChordUtilities

/// The  Chord Edit View
struct ChordEditView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// MIDI instrument
    @AppStorage("MIDI instrument") private var midiInstrument: MidiPlayer.Instrument = .acousticNylonGuitar
    /// Dismiss for the sheet
    @Environment(\.dismiss) var dismiss
    /// The chord to add or change
    let chord: ChordPosition
    /// The values in the form
    @State private var values: CustomChord
    /// The resulting chord
    @State private var result: ChordPosition
    /// Status of the chord, new or altered
    @State private var status: Status = .new
    /// The ID of an existsing chord
    @State private var chordID: Int?
    /// The chord info result
    @State private var chordInfo: Chord?

    /// Init the form
    init(chord: ChordPosition) {
        self.chord = chord
        _result = State(wrappedValue: chord)
        _values = State(wrappedValue: CustomChord(id: chord.id,
                                                  frets: chord.frets,
                                                  fingers: chord.fingers,
                                                  baseFret: chord.baseFret,
                                                  barres: chord.barres,
                                                  bar: chord.barres.first ?? 0,
                                                  capo: chord.capo,
                                                  root: chord.key,
                                                  quality: chord.suffix)
        )
    }
    /// The body of the View
    var body: some View {
        VStack {
            Text("\(values.root.rawValue) \(values.quality.rawValue)")
                .font(.title)
            chordFinder(chord: result)
            Text(result.define)
                .textSelection(.enabled)
                .font(.headline)
                .padding()
            Picker("Key:", selection: $values.root) {
                ForEach(Chords.Root.allCases, id: \.rawValue) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom)
            HStack {
                Picker("Suffix:", selection: $values.quality) {
                    ForEach(Chords.Quality.allCases, id: \.rawValue) { value in
                        Text(value.rawValue)
                            .tag(value)
                    }
                }
                Picker("Base fret:", selection: $values.baseFret) {
                    ForEach(1...20, id: \.self) { value in
                        Text(value.description)
                            .tag(value)
                    }
                }
                Picker("Barres:", selection: $values.bar) {
                    Text("None")
                        .tag(0)
                    ForEach(1...5, id: \.self) { value in
                        Text(value.description)
                            .tag(value)
                    }
                }
            }
            HStack {
                VStack {
                    model.diagram(chord: result, frame: CGRect(x: 0, y: 0, width: 200, height: 300))
                    HStack {
                        Divider()
                            .frame(height: 20)
                        ForEach(result.notes) { note in
                            Text(note.note.display.symbol)
                                .frame(width: 18)
                            Divider()
                                .frame(height: 20)
                        }
                    }
                    HStack {
                        Divider()
                            .frame(height: 20)
                        ForEach(chord.midi, id: \.self) { note in
                            Text("\(note)")
                                .frame(width: 18)
                            Divider()
                                .frame(height: 20)
                        }
                    }
                    HStack {
                        MidiPlayer.InstrumentPicker()
                        .frame(width: 180)
                        .labelsHidden()
                        MidiPlayer.PlayButton(chord: result)
                    }
                    if let chordInfo {
                        HStack {
                            Text("**\(chordInfo.display)** contains")
                            ForEach(chordInfo.components(), id: \.self) { component in
                                Text(component.display.symbol)
                            }
                        }
                    }
                }
                .frame(width: 400)
                VStack {
                    Section(
                        content: {
                            HStack {
                                ForEach(GuitarTuning.allCases, id: \.rawValue) { fret in
                                    Picker(
                                        selection: $values.frets[fret.rawValue],
                                        content: {
                                            Text("⛌")
                                                .tag(-1)
                                                .foregroundColor(.red)
                                            ForEach(0...5, id: \.self) { value in
                                                Text(value.description)
                                                    .tag(value)
                                            }
                                        },
                                        label: {
                                            Text(String(describing: fret))
                                                .font(.title2)
                                        }
                                    )
                                    Divider()
                                }
                            }
                            .pickerStyle(.radioGroup)
                        }, header: {
                            header(text: "Frets")
                        })
                    Section(
                        content: {
                            HStack {
                                ForEach(GuitarTuning.allCases, id: \.rawValue) { finger in
                                    Picker(
                                        selection: $values.fingers[finger.rawValue],
                                        content: {
                                            ForEach(0...4, id: \.self) { value in
                                                Text(value.description)
                                                    .tag(value)
                                            }
                                        },
                                        label: {
                                            Text(String(describing: finger))
                                                .font(.title2)
                                        }
                                    )
                                    Divider()
                                }
                            }
                            .pickerStyle(.radioGroup)
                        }, header: {
                            header(text: "Fingers")
                        })
                }
            }
            Divider()
                .padding(.top)
            HStack {
                Button(action: {
                    switch status {
                    case .new:
                        model.allChords.append(result)
                    case .update:
                        if let index = chordID {
                            model.allChords[index] = result
                        }
                    }
                    model.updateDocument.toggle()
                    dismiss()
                }, label: {
                    Text(status.rawValue)
                })
                .disabled(chord == result)
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                })
            }
        }
        .padding()
        .task {
            if let index = model.allChords.firstIndex(where: {$0.id == values.id}) {
                status = .update
                chordID = index
            }
        }
        .animation(.default, value: chordInfo?.name)
        .task(id: values) {
            result = ChordPosition(id: values.id,
                                       frets: values.frets,
                                       fingers: values.fingers,
                                       baseFret: values.baseFret,
                                       barres: values.bar != 0 ? [values.bar] : [],
                                       midi: values.midi.map({$0.note}),
                                       key: values.root,
                                       suffix: values.quality
            )
            chordInfo = getChordInfo(root: values.root, quality: values.quality)
        }
    }

    func header(text: String) -> some View {
        VStack {
            Text(text)
                .font(.title2)
                .padding(.top)
            Divider()
        }
    }

    func chordFinder(chord: ChordPosition) -> some View {
        HStack {
            Text(chord.chordFinder.isEmpty ? "Found nothing" : "Found")
            ForEach(chord.chordFinder) { result in
                Text(result.display)
                    .foregroundColor(chord.name == result.name ? .accentColor : .primary)
            }
        }
    }

    enum Status: String {
        case new = "Save New Chord"
        case update = "Update Chord"
    }
}
