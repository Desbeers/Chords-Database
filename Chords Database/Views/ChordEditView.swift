//
//  ChordEditView.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftyChords

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
    /// The chord guess result
    @State private var chordGuess: ChordUtilities.Chord?
    
    /// Init the form
    init(chord: ChordPosition) {
        self.chord = chord
        _result = State(wrappedValue: chord)
        _values = State(wrappedValue: CustomChord(id: chord.id,
                                            frets: chord.frets,
                                            fingers: chord.fingers,
                                            baseFret: chord.baseFret,
                                            barres: chord.barres.first ?? 0,
                                            capo: chord.capo,
                                            key: chord.key,
                                            suffix: chord.suffix)
        )
    }
    /// The body of the View
    var body: some View {
        VStack {
            Text("\(values.key.rawValue) \(values.suffix.rawValue)")
                .font(.title)
            chordFinder(chord: result)
            Text(result.define)
                .textSelection(.enabled)
                .font(.headline)
                .padding()
            Picker("Key:", selection: $values.key) {
                ForEach(Chords.Key.allCases, id: \.rawValue) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom)
            HStack {
                Picker("Suffix:", selection: $values.suffix) {
                    ForEach(Chords.Suffix.allCases, id: \.rawValue) { value in
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
                Picker("Barres:", selection: $values.barres) {
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
                        ForEach(values.midi) { midi in
                            Text("\(midi.key.display.symbol)")
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
                    if let chordGuess {
                        HStack {
                            Text("**\(result.lookup)** contains")
                            ForEach(chordGuess.components(), id: \.self) { component in
                                Text(component)
                            }
                        }
                    }
                }
                .frame(width: 400)
                VStack {
                    Section(
                        content: {
                            HStack {
                                ForEach(Strings.allCases, id: \.rawValue) { fret in
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
                                ForEach(Strings.allCases, id: \.rawValue) { finger in
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
        .animation(.default, value: chordGuess?.root)
        .animation(.default, value: chordGuess?.quality.quality)
        .task(id: values) {
            result = ChordPosition(id: values.id,
                                       frets: values.frets,
                                       fingers: values.fingers,
                                       baseFret: values.baseFret,
                                       barres: values.barres != 0 ? [values.barres] : [],
                                       midi: values.midi.map({$0.note}),
                                       key: values.key,
                                       suffix: values.suffix
            )
            chordGuess = ChordUtilities.Chord(chord: result.lookup)
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
                Text(result.chord)
                    .foregroundColor(chord.lookup == result.chord ? .green : .primary)
            }
        }
    }

    enum Status: String {
        case new = "Save New Chord"
        case update = "Update Chord"
    }
}
