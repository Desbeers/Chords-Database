//
//  ExportDatabase.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

/// - Note: Not in use, but I keep it if the structure of the database will change

import SwiftUI
import SwiftlyChordUtilities
import UniformTypeIdentifiers

struct ExportButton: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel

    /// Chord Display Options
    @EnvironmentObject private var options: ChordDisplayOptions

    @State private var showExport: Bool = false
    @State private var data: Data?
    var body: some View {
        Button("Export new database version") {
            showExport.toggle()
        }
        .fileExporter(
            isPresented: $showExport,
            document: ChordsDatabaseDocument(chords: exportChords),
            contentType: .chordsdb,
            defaultFilename: "New Database"
        ) { result in
            if case .success = result {
                print("Success")
            } else {
                print("Failure")
            }
        }
    }

    private var exportChords: String {
        return ""

//        let definitions = model.allChords.map(\.define).sorted()
//        let export = Database(
//            instrument: options.displayOptions.instrument,
//            definitions: definitions
//        )
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        do {
//            let encodedData = try encoder.encode(export)
//            let jsonString = String(
//                data: encodedData,
//                encoding: .utf8
//            )
//            return jsonString ?? "error"
//        } catch {
//            return "error"
//        }
    }
}

struct DirectiveExport: Codable {
    let id: UUID
    let root: Chord.Root
    let quality: Chord.Quality
    let define: String
}
