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
    
    var chordNotes: [ChordNote] {
        var notes: [ChordNote] = []
        for note in self.midi {
            if let midiNote = Midi(rawValue: ((note - 40) % 12)) {
                // -TODO: +4 because MIDI starts with E
                let test = ChordUtilities.valueToNote(value: (midiNote.rawValue + 4), scale: self.key)
                notes.append(ChordNote(note: test))
            }
        }
        return notes
    }
    
    struct ChordNote: Identifiable, Hashable {
        let id = UUID()
        var note: Chords.Key
    }
}

extension ChordPosition {
    var chordFinder: [ChordUtilities.Chord] {
        ChordUtilities.findChordsFromNotes(notes: chordNotes.map({$0.note}).unique(by: {$0}))
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
