//
//  CustomChord.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftyChords

// MARK: Custom Chords

/// A custom chord in 'Chord Provider`
struct CustomChord: Equatable {
    public var id: UUID
    public var frets: [Int]
    public var fingers: [Int]
    public var baseFret: Int
    public var barres: Int
    public var capo: Bool?
    public var midi: [Midi.Note] {
        return Midi.values(values: self)
    }
    public var key: Chords.Key
    public var suffix: Chords.Suffix
}
