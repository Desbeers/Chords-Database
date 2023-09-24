//
//  ChordEditView2.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

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
        }
        .animation(.default, value: options.displayOptions)
        .task {
            if let index = model.allChords.firstIndex(where: { $0.id == chord.id }) {
                status = .update
                chordID = index
            }
        }
    }


    enum Status: String {
        case new = "Save New Chord"
        case update = "Update Chord"
    }
}
