//
//  ChordEditView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// The  Chord Edit View
struct ChordEditView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// Chord Display Options
    @EnvironmentObject var options: ChordDisplayOptions
    /// The chord to add or change
    let chord: ChordDefinition
    /// Status of the chord, new or altered
    @State private var status: Status = .new
    /// The ID of an existsing chord
    @State private var chordID: Int?
    /// The chord finder result
    @State private var chordFinder: [ChordDefinition] = []
    /// The chord diagram
    @State private var diagram: ChordDefinition?
    /// The body of the `View`
    var body: some View {
        VStack {
            Text("\(options.definition.root.rawValue) \(options.definition.quality.rawValue)")
                .font(.title)
            Text(options.definition.define)
                .textSelection(.enabled)
                .font(.headline)
                .padding()
            options.rootPicker
                .pickerStyle(.segmented)
                .padding(.bottom)
            HStack {
                LabeledContent(content: {
                    options.qualityPicker
                        .labelsHidden()
                }, label: {
                    Text("Quality:")
                })
                .frame(maxWidth: 150)
                LabeledContent(content: {
                    Picker("Base fret:", selection: $options.definition.baseFret) {
                        ForEach(1...20, id: \.self) { value in
                            Text(value.description)
                                .tag(value)
                        }
                    }
                    .labelsHidden()
                }, label: {
                    Text("Base fret:")
                })
                .frame(maxWidth: 150)
            }
            HStack {
                VStack {
                    if let diagram {
                        DiagramView(chord: diagram, width: 200)
                        chordFinderList
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 300, height: 450)
                fretsAndFingers
            }
            Divider()
                .padding(.top)
            HStack {
                Button(action: {
                    switch status {
                    case .new:
                        model.allChords.append(options.definition)
                    case .update:
                        if let index = chordID, let diagram = diagram {
                            model.allChords[index] = diagram
                        }
                    }
                    model.updateDocument.toggle()
                    _ = model.navigationStack.popLast()
                }, label: {
                    Text(status.rawValue)
                })
                .disabled(chord == options.definition)
                .padding(.trailing)
                Button(action: {
                    _ = model.navigationStack.popLast()
                }, label: {
                    Text("Cancel")
                })
                .padding(.leading)
            }
        }
        .padding()
        .navigationTitle("Edit")
        .animation(.default, value: options.displayOptions)
        .animation(.default, value: options.definition)
        .task {
            options.definition = chord
            if let index = model.allChords.firstIndex(where: { $0.id == chord.id }) {
                status = .update
                chordID = index
            }
        }
        .task(id: options.definition) {
            let diagram = ChordDefinition(
                id: options.definition.id,
                name: options.definition.name,
                frets: options.definition.frets,
                fingers: options.definition.fingers,
                baseFret: options.definition.baseFret,
                root: options.definition.root,
                quality: options.definition.quality,
                status: .standard
            )
            chordFinder = diagram.chordFinder
            self.diagram = diagram
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

    var chordFinderList: some View {
        HStack {
            Text(chordFinder.isEmpty ? "Found nothing" : "Found")
            ForEach(chordFinder) { result in
                Text(result.displayName(options: .init(rootDisplay: .symbol, qualityDisplay: .symbolized)))
                    .foregroundColor(
                        chord.root == result.root && chord.quality == result.quality ? .accentColor : .primary
                    )
            }
        }
    }

    enum Status: String {
        case new = "Save New Chord"
        case update = "Update Chord"
    }
}
