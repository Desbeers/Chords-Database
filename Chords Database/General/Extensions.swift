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

    /// Convert a `ChordPosition` into a ChordPro `{define}`
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
    
    var notes: [Note] {
        var notes: [Note] = []
        for note in self.midi {
            let key = ChordUtilities.valueToNote(value: (note), scale: self.key)
            notes.append(Note(note: key))
        }
        return notes
    }
    
    struct Note: Identifiable, Hashable {
        let id = UUID()
        var note: Chords.Key
    }
}

extension ChordPosition {
    var chordFinder: [ChordUtilities.Chord] {
        ChordUtilities.findChordsFromNotes(notes: notes.map({$0.note}).unique(by: {$0}))
    }
}

extension ChordPosition {

    /// The full name of the chord
    var name: String {
        return "\(key.rawValue)\(suffix.rawValue)"
    }
}

extension ChordPosition {

    /// Play a chord with MIDI
    /// - Parameter instrument: The `instrument` to use
    func play(instrument: MidiPlayer.Instrument = .acousticNylonGuitar) {
        Task {
            await MidiPlayer.shared.playNotes(notes: self.midi, instument: instrument)
        }
    }
}
