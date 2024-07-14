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

/// SwiftUI `View` to export the database
struct ExportButton: View {
    /// The SwiftUI model for the Chords Database
    @Environment(ChordsDatabaseModel.self) private var chordsDatabaseModel
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
    /// Bool to show the file exporter dialog
    @State private var showExport: Bool = false
    /// The body of the `View`
    var body: some View {
        Button("Export to **ChordPro** format") {
            showExport.toggle()
        }
        .fileExporter(
            isPresented: $showExport,
            document: JSONDocument(string: exportChords),
            contentTypes: [.json, .chordsdb],
            defaultFilename: "ChordPro Guitar Chords"
        ) { result in
            if case .success = result {
                print("Success")
            } else {
                print("Failure")
            }
        }
    }

    private var exportChords: String {
        /// Only export basic chords
        let definitions = chordsDatabaseModel.allChords.uniqued(by: \.name).filter {$0.root.accidental != .flat }

        var chords = definitions.map { chord in
            ChordProChordDefinition.Chord(
                name: chord.name,
                base: chord.baseFret,
                frets: chord.frets,
                fingers: chord.fingers,
                copy: nil
            )
        }

        for root in Chord.Root.allCases where root.accidental == .flat {
            for copy in definitions.filter({ $0.root.copy == root }) {

                var name = root.rawValue
                name += copy.quality.rawValue
                if let bass = copy.bass {
                    name += "/\(bass.rawValue)"
                }

                chords.append(
                    .init(
                        name: name,
                        base: nil,
                        frets: nil,
                        fingers: nil,
                        copy: copy.name
                    )
                )
            }
        }

        let export = ChordProChordDefinition(
            instrument: .init(
                description: "Guitar, 6 strings, standard tuning",
                type: "guitar"
            ),
            tuning: ["E2", "A2", "D3", "G3", "B3", "E4"],
            chords: chords,
            pdf: .init(diagrams: .init(vcells: 6))
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let encodedData = try encoder.encode(export)
            return String(decoding: encodedData, as: UTF8.self)
        } catch {
            return "error"
        }
    }
}
