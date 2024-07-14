//
//  ChordProChordDefinition.swift
//  Chords Database
//
//  Created by Nick Berendsen on 14/07/2024.
//

import Foundation

// MARK: - ChordProChordDefinition
struct ChordProChordDefinition: Codable {
    let instrument: Instrument
    let tuning: [String]
    let chords: [Chord]
    let pdf: PDF
}

extension ChordProChordDefinition {

    // MARK: - Chord
    struct Chord: Codable {
        let name: String
        let base: Int?
        let frets: [Int]?
        let fingers: [Int]?
        let copy: String?
    }

    // MARK: - Instrument
    struct Instrument: Codable {
        let description, type: String
    }

    // MARK: - PDF
    struct PDF: Codable {
        let diagrams: Diagrams
    }

    // MARK: - Diagrams
    struct Diagrams: Codable {
        let vcells: Int
    }
}
