//
//  ChordsDatabaseDocument.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers
import SwiftlyChordUtilities

// MARK: The Chord Database document

extension UTType {
    /// Add the UIType for the Chord Database document
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
        self.chords = chords
    }
    /// Init for an existing document
    init(configuration: ReadConfiguration) throws {
        guard
            let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        chords = String(decoding: data, as: UTF8.self)
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
