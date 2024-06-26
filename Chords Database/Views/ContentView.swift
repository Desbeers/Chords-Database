//
//  ContentView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` containing all content
struct ContentView: View {
    /// The default display options for the diagrams
    static let defaults = ChordDefinition.DisplayOptions(
        showName: true,
        showNotes: true,
        showPlayButton: true,
        rootDisplay: .symbol,
        qualityDisplay: .symbolized,
        showFingers: true,
        mirrorDiagram: false
    )
    /// Chord Display Options
    @State private var chordDisplayOptions = ChordDisplayOptions(defaults: defaults)
    /// The SwiftUI model for the Chords Database
    @State var model = ChordsDatabaseModel()
    /// Chord Display Options
    /// The current document with the databse
    @Binding var document: ChordsDatabaseDocument
    /// The body of the `View`
    var body: some View {
        MainView()
            .environment(chordDisplayOptions)
            .environment(model)
            .sheet(
                isPresented: $model.showTemplate,
                onDismiss: {
                    switch chordDisplayOptions.displayOptions.instrument {
                    case .guitarStandardETuning:
                        model.allChords = Chords.guitar
                    case .guitaleleStandardATuning:
                        model.allChords = Chords.guitalele
                    case .ukuleleStandardGTuning:
                        model.allChords = Chords.ukulele
                    }
                    model.instrument = chordDisplayOptions.displayOptions.instrument
                    model.updateDocument.toggle()
                },
                content: {
                    TemplateView()
                        .environment(chordDisplayOptions)
                }
            )
        /// Import the chords
            .task {
                if document.chords.isEmpty {
                    model.showTemplate = true
                } else {
                    /// Load the content of the database
                    model.allChords = Chords.importDatabase(database: document.chords)
                    /// Set the instrument
                    if let firstDefinition = model.allChords.first {
                        model.instrument = firstDefinition.instrument
                    }
                }
            }
        /// Store changes of chords in the document
            .onChange(of: model.updateDocument ) {
                document.chords = Chords.exportDatabase(definitions: model.allChords)
            }
    }
}
