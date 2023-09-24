//
//  ChordsDatabaseDocument.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers
import SwiftlyChordUtilities

// MARK: The Chord Databse document

extension UTType {
    /// Add the UIType for the Chord Databse document
    static var chordsdb: UTType {
        UTType(exportedAs: "nl.desbeers.chordsdb")
    }
}

/// The Chords database document
struct ChordsDatabaseDocument: FileDocument {

    /// The type of the document
    static var readableContentTypes: [UTType] { [.chordsdb] }
    /// The content of the document
    var chords: String
    /// Init the document
    init(chords: String = "") {
//        if chords.isEmpty {
//            self.chords = Chords.jsonDatabase(instrument: .guitarStandardETuning)
//        } else {
//            self.chords = chords
//        }
        self.chords = chords
    }
    /// Init for an existing document
    init(configuration: ReadConfiguration) throws {
        guard
            let data = configuration.file.regularFileContents,
            let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        chords = string
    }
    /// Write the document
    /// - Parameter configuration: The `WriteConfiguration`
    /// - Returns: A `FileWrapper`
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        // swiftlint:disable:next force_unwrapping
        let data = chords.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}
