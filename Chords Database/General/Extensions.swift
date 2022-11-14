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
    
    var chordNotes: [String] {
        var notes: [String] = []
        for note in self.midi {
            if let midiNote = Midi(rawValue: ((note - 40) % 12)) {
                notes.append(midiNote.key.rawValue)
            }
        }
        return notes
    }
}

extension ChordPosition {
    
    var chordFinder: [ChordUtilities.Chord] {
        ChordUtilities.findChordsFromNotes(notes: chordNotes.unique(by: {$0}))
    }
}

extension ChordPosition {
    
    var lookup: String {
        
        var name = key.rawValue
        
        switch suffix {
        case .major:
            name += "maj"
        case .minor:
            name += "m"
        default:
            if suffix.rawValue.contains("/") {
                name += suffix.rawValue
            } else {
                name += suffix.display.short.lowercased()
            }
        }
        return name
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
