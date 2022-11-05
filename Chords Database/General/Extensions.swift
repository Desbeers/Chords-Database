//
//  Extensions.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftyChords

// MARK: Sequence extensions

extension Sequence {

    /// Filter a sequence by a certain tag
    /// - Returns: The filtered sequence
    public func unique<T: Hashable>(by taggingHandler: (_ element: Self.Iterator.Element) -> T) -> [Self.Iterator.Element] {
        var knownTags = Set<T>()
        return self.filter { element -> Bool in
            let tag = taggingHandler(element)
            if !knownTags.contains(tag) {
                knownTags.insert(tag)
                return true
            }
            return false
        }
    }
}

// MARK: Swifty Chords extensions

extension ChordPosition {

    // swiftlint:disable multiline_parameters_brackets
    init(
        id: UUID = UUID(),
        frets: [Int],
        fingers: [Int],
        baseFret: Int,
        barres: [Int],
        capo: Bool? = nil,
        midi: [Int],
        key: Chords.Key,
        suffix: Chords.Suffix) throws {
            let data = """
    {
        "key": "\(key.rawValue)",
        "suffix": "\(suffix.rawValue)",
        "midi": \(midi),
        "baseFret": \(baseFret),
        "frets": \(frets),
        "fingers": \(fingers),
        "barres": \(barres)
    }
"""
            let decoder = JSONDecoder()
            self = try decoder.decode(ChordPosition.self, from: data.data(using: .utf8)!)
        }
    // swiftlint:enable multiline_parameters_brackets
}

extension ChordPosition {

    var define: String {
        var define = "{define: "
        define += key.rawValue + suffix.rawValue
        define += " base-fret "
        define += baseFret.description
        define += " frets "
        for fret in frets {
            define += "\(fret == -1 ? "x" : fret.description) "
        }
        define += "fingers "
        for finger in fingers {
            define += "\(finger) "
        }
        define += "}"
        return define
    }
}

extension ChordPosition {

    func play(instrument: MidiPlayer.Instrument = .acousticNylonGuitar) {
        Task {
            await MidiPlayer.shared.playNotes(notes: self.midi, instument: instrument)
        }
    }
}

extension Chords.Key: Comparable {
    /// Implement Comparable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}

extension Chords.Suffix: Comparable {
    /// Implement Comparable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}
