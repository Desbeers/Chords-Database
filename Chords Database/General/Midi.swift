//
//  Midi.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftyChords

// MARK: Midi

/// Convert `fret` positions to MIDI notes
enum Midi {
    /// Just a placeholder
}

extension Midi {

    /// The struct for a MIDI note
    struct Note: Identifiable {
        /// The unique ID
        var id = UUID()
        /// The MIDI note number
        let note: Int
        /// The key of the MIDI note
        let key: Chords.Root
        /// The octave of the MIDI note
        var octave: Int {
            Int(round(Double(note - 17) / 12))
        }
    }
}

extension Midi {
    
    // MARK: Fret positions to MIDI values
    
    /// Calculate the MIDI values for a `CustomChord` struct
    /// - Parameter values: The `CustomChord` midi values in a ``Note`` array
    /// - Returns: An array of ``Midi/Note``'s
    static func values(values: CustomChord) -> [Midi.Note] {
        return calculate(frets: values.frets, baseFret: values.baseFret)
    }
    
    /// Calculate the MIDI values for a `ChordPosition` struct
    /// - Parameter values: The `ChordPosition` midi values
    /// - Returns: An array of `Int`'s
    static func values(values: ChordPosition) -> [Int] {
        return calculate(frets: values.frets, baseFret: values.baseFret).map({ $0.note })
    }
    
    /// Calculate the MIDI values
    private static func calculate(frets: [Int], baseFret: Int) -> [Midi.Note] {
        var midiNotes: [Midi.Note] = []
        print("_____")
        for string in GuitarTuning.allCases {
            var fret = frets[string.rawValue]
            /// Don't bother with ignored frets
            if fret != -1 {
                /// Add base fret if the fret is not 0 and the offset
                fret += string.offset + (fret == 0 ? 1 : baseFret) + 40
                let key = ChordUtilities.valueToNote(value: fret + 4)
                midiNotes.append(Midi.Note(note: fret, key: key))
            }
        }
        return midiNotes
    }
}
