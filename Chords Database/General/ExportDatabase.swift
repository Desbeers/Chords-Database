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
//        let export = model.allChords.map { chord in
//            CustomChord(
//                id: chord.id,
//                frets: chord.frets,
//                fingers: chord.fingers,
//                baseFret: chord.baseFret,
//                //barres: chord.barres,
//                root: chord.key,
//                quality: chord.suffix
//            )
//        }
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        do {
//            let encodedData = try encoder.encode(export)
//            let jsonString = String(data: encodedData,
//                                    encoding: .utf8)
//            return jsonString ?? "error"
//        } catch {
//            return "error"
//        }
    }
}
