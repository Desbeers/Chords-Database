//
//  ContentView.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The  Content View
struct ContentView: View {
    /// The SwiftUI model for the Chords Database
    @StateObject var model = ChordsDatabaseModel()
    /// The current document with the databse
    @Binding var document: ChordsDatabaseDocument
    /// The body of the View
    var body: some View {
        MainView()
            .environmentObject(model)
        /// Import the chords
            .task {
                if document.chords == "default" {
                    /// Load the default database
                    model.allChords = ChordsDatabaseModel.getChords()
                    /// Update the document
                    model.updateDocument.toggle()
                } else {
                    /// Load the content of the database
                    model.importDB(database: document.chords)
                }
            }
        /// Store changes of chords in the document
            .onChange(of: model.updateDocument ) { _ in
                document.chords = model.exportDB
            }
    }
}
