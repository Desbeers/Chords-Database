//
//  ChordsDatabaseDocument.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers

// MARK: The Chord Databse document

extension UTType {
    
    /// Add the UIType for the Chord Databse document
    static var cdb: UTType {
        UTType(importedAs: "nl.desbeers.cdb")
    }
}

/// The Chords database document
struct ChordsDatabaseDocument: FileDocument {
    /// The type of the document
    static var readableContentTypes: [UTType] { [.cdb] }
    /// The content of the document
    var chords: String
    /// Init the document
    init(chords: String = "default") {
        self.chords = chords
    }
    /// Init for an existing document
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
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
        let data = chords.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}
