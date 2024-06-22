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
    @Environment(ChordsDatabaseModel.self) private var chordsDatabaseModel
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
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
        @Bindable var chordDisplayOptions = chordDisplayOptions
        ScrollView {
            VStack {
                CreateChordView(chordDisplayOptions: $chordDisplayOptions)
                Divider()
                    .padding(.top)
                HStack {
                    Button(action: {
                        let result = ChordDefinition(
                            id: chordDisplayOptions.definition.id,
                            name: chordDisplayOptions.definition.name,
                            frets: chordDisplayOptions.definition.frets,
                            fingers: chordDisplayOptions.definition.fingers,
                            baseFret: chordDisplayOptions.definition.baseFret,
                            root: chordDisplayOptions.definition.root,
                            quality: chordDisplayOptions.definition.quality,
                            bass: chordDisplayOptions.definition.bass,
                            instrument: chordDisplayOptions.definition.instrument,
                            status: .standardChord
                        )
                        switch status {
                        case .new:
                            chordsDatabaseModel.allChords.append(result)
                        case .update:
                            if let index = chordID {
                                chordsDatabaseModel.allChords[index] = result
                            }
                            /// Sharp/Flat
                            if
                                editSharpAndFlat,
                                let index = sharpFlatchordID,
                                let root = Chords_Database.sharpFlat(root: result.root) {
                                let result = ChordDefinition(
                                    id: chordDisplayOptions.definition.id,
                                    name: chordDisplayOptions.definition.name,
                                    frets: chordDisplayOptions.definition.frets,
                                    fingers: chordDisplayOptions.definition.fingers,
                                    baseFret: chordDisplayOptions.definition.baseFret,
                                    root: root,
                                    quality: chordDisplayOptions.definition.quality,
                                    bass: chordDisplayOptions.definition.bass,
                                    instrument: chordDisplayOptions.definition.instrument,
                                    status: .standardChord
                                )
                                chordsDatabaseModel.allChords[index] = result
                            }
                        }
                        chordsDatabaseModel.updateDocument.toggle()
                        _ = chordsDatabaseModel.navigationStack.popLast()
                    }, label: {
                        Text(status.rawValue)
                    })
                    .disabled(chord == chordDisplayOptions.definition)
                    .padding(.trailing)
                    Button(action: {
                        _ = chordsDatabaseModel.navigationStack.popLast()
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
        .animation(.default, value: chordDisplayOptions.displayOptions)
        .task {
            sharpFlat = Chords_Database.sharpFlat(root: chord.root)
            if let index = chordsDatabaseModel.allChords.firstIndex(where: { $0.id == chord.id }) {
                status = .update
                chordID = index

                if let sharpFlat, let sharpFlatIndex = chordsDatabaseModel.allChords.firstIndex(where: {
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
