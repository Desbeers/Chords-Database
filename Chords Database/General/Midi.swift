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
enum Midi: Int {
    // swiftlint:disable identifier_name
    case e
    case f
    case fSharp
    case g
    case gSharp
    case a
    case aSharp
    case b
    case c
    case cSharp
    case d
    case dSharp
    // swiftlint:enable identifier_name
}

extension Midi {
    
    /// The Key of the MIDI note
    var key: Chords.Key {
        Chords.Key(rawValue: name) ?? .c
    }
}

extension Midi {
    
    /// The name of the MIDI note
    var name: String {
        switch self {
        case .e:
            return "E"
        case .f:
            return "F"
        case .fSharp:
            return "F#"
        case .g:
            return "G"
        case .gSharp:
            return "G#"
        case .a:
            return "A"
        case .aSharp:
            return "A#"
        case .b:
            return "B"
        case .c:
            return "C"
        case .cSharp:
            return "C#"
        case .d:
            return "D"
        case .dSharp:
            return "D#"
        }
    }
}

extension Midi {
    
    /// The base MIDI values for a guitar
    var baseValue: Int {
        switch self {
        case .e:
            return 40
        case .f:
            return 41
        case .fSharp:
            return 42
        case .g:
            return 43
        case .gSharp:
            return 44
        case .a:
            return 45
        case .aSharp:
            return 46
        case .b:
            return 47
        case .c:
            return 48
        case .cSharp:
            return 49
        case .d:
            return 50
        case .dSharp:
            return 51
        }
    }
}

extension Midi {

    /// The struct for a MIDI note
    struct Note: Identifiable {
        /// The unique ID
        var id = UUID()
        /// The MIDI note number
        let note: Int
        /// The key of the MIDI note
        let key: Chords.Key
        /// The octave of the MIDI note
        var octave: Int {
            Int(round(Double(note - 17) / 12))
        }
    }
}

extension Midi {
    
    // MARK: Fret positions to MIDI values
    
    /// Calculate the MIDI values for a Chord struct
    /// - Parameter values: The `CustomChord` values
    /// - Returns: An array of ``Midi/Note``'s
    static func values(values: CustomChord) -> [Midi.Note] {
        return calculate(frets: values.frets, baseFret: values.baseFret)
    }
    
    /// Calculate the MIDI values for a ChordPosition struct
    /// - Parameter values: The `ChordPosition` values
    /// - Returns: An array of `Int`'s
    static func values(values: ChordPosition) -> [Int] {
        return calculate(frets: values.frets, baseFret: values.baseFret).map({ $0.note })
    }
    
    /// Calculate the MIDI values
    private static func calculate(frets: [Int], baseFret: Int) -> [Midi.Note] {
        var midiNotes: [Midi.Note] = []
        for string in Strings.allCases {
            var fret = frets[string.rawValue]
            /// Don't bother with ignored frets
            if fret != -1 {
                /// Add base fret if the fret is not 0 and the offset
                fret += string.offset + (fret == 0 ? 1 : baseFret)
                /// Find the base midi value
                if let midiNote = Midi(rawValue: (fret) % 12), let key = Chords.Key(rawValue: midiNote.name) {
                    let midiValue = midiNote.baseValue + ((fret / 12) * 12)
                    midiNotes.append(Midi.Note(note: midiValue, key: key))
                    
                }
            }
        }
        return midiNotes
    }
}
