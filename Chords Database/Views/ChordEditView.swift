//
//  ChordEditView2.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` to edit a chord
struct ChordEditView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// Chord Display Options
    @EnvironmentObject var options: ChordDisplayOptions
    /// The chord to add or change
    let chord: ChordDefinition
    /// Status of the chord, new or altered
    @State private var status: Status = .new
    /// The ID of an existing chord
    @State private var chordID: Int?

    @State private var sharpFlat: Chord.Root?

    @AppStorage("SharpAndFlat") var editSharpAndFlat: Bool = true

    /// The ID of an existing chord
    @State private var sharpFlatchordID: Int?

    /// The body of the `View`
    var body: some View {
        ScrollView {
            VStack {
                CreateChordView()
                Divider()
                    .padding(.top)
                HStack {
                    Button(action: {
                        let result = ChordDefinition(
                            id: options.definition.id,
                            name: options.definition.name,
                            frets: options.definition.frets,
                            fingers: options.definition.fingers,
                            baseFret: options.definition.baseFret,
                            root: options.definition.root,
                            quality: options.definition.quality,
                            bass: options.definition.bass,
                            instrument: options.definition.instrument,
                            status: .standard
                        )
                        switch status {
                        case .new:
                            model.allChords.append(result)
                        case .update:
                            if let index = chordID {
                                model.allChords[index] = result
                            }
                            /// Sharp/Flat
                            if
                                editSharpAndFlat,
                                let index = sharpFlatchordID,
                                let root = Chords_Database.sharpFlat(root: result.root)
                            {
                                let result = ChordDefinition(
                                    id: options.definition.id,
                                    name: options.definition.name,
                                    frets: options.definition.frets,
                                    fingers: options.definition.fingers,
                                    baseFret: options.definition.baseFret,
                                    root: root,
                                    quality: options.definition.quality,
                                    bass: options.definition.bass,
                                    instrument: options.definition.instrument,
                                    status: .standard
                                )
                                model.allChords[index] = result
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
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    if status == .update, let sharpFlat {
                        VStack {
                            Toggle(isOn: $editSharpAndFlat) {
                                Text("Also \(status == .new ? "add" : "edit") **\(sharpFlat.display.symbol)** version")
                            }
                            Text(chordID?.description ?? "No ID")
                            Text(sharpFlatchordID?.description ?? "No ID")
                        }
                    }
                }
            }
            .padding()
        }
        .animation(.default, value: options.displayOptions)
        .task {
            sharpFlat = Chords_Database.sharpFlat(root: chord.root)
            if let index = model.allChords.firstIndex(where: { $0.id == chord.id }) {
                status = .update
                chordID = index

                if let sharpFlat, let sharpFlatIndex = model.allChords.firstIndex(where: {
                    $0.root == sharpFlat &&
                    $0.quality == chord.quality &&
                    $0.baseFret == chord.baseFret &&
                    $0.bass == chord.bass &&
                    $0.frets == chord.frets &&
                    $0.fingers == chord.fingers
                }) {
                    sharpFlatchordID = sharpFlatIndex
                }
            }
        }
    }


    enum Status: String {
        case new = "Add New Chord"
        case update = "Update Chord"
    }
}
