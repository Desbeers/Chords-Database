//
//  Midi.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftyChords

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
    
    /// The struct for a MIDI note
    struct Note: Identifiable {
        /// The unique ID
        var id = UUID()
        /// The MIDI note number
        let note: Int
        /// The MIDI note name
        let name: String
    }
}

extension Midi {
    
    /// The base MIDI values for a guitar
    var value: Int {
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
    
    /// Name display for a MIDI note
    var display: (accessible: String, symbol: String) {
        switch self {
        case .c:
            return ("C", "C")
        case .cSharp:
            return ("C sharp", "C♯")
        case .d:
            return ("D", "D")
        case .dSharp:
            return ("D sharp", "D♯")
        case .e:
            return ("E", "E")
        case .f:
            return ("F", "F")
        case .fSharp:
            return ("F sharp", "F♯")
        case .g:
            return ("G", "G")
        case .gSharp:
            return ("G sharp", "G♯")
        case .a:
            return ("A", "A")
        case .aSharp:
            return ("A sharp", "A♯")
        case .b:
            return ("B", "B")
        }
    }
}

extension Midi {
    
    // MARK: Fret positions to MIDI values
    
    /// Calculate the MIDI values for a Chord struct
    /// - Parameter values: The `Chord` values
    /// - Returns: An array of ``Midi/Note``'s
    static func values(values: Chord) -> [Midi.Note] {
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
                /// Add base fret and the offset
                fret += baseFret + string.offset
                /// Find the base midi value
                if let midiNote = Midi(rawValue: (fret) % 12) {
                    let midi = midiNote.value + ((fret / 12) * 12)
                    midiNotes.append(.init(note: midi,
                                           name: midiName(note: midi))
                    )
                }
            }
            
        }
        return midiNotes
    }
    
    /// Convert a MIDI note to a name
    private static func midiName(note: Int) -> String {
        if let midiNote = Midi(rawValue: ((note - 40) % 12)) {
            let number = (note - 40) / 12 + 2
            return "\(midiNote.display.symbol)\(number.description)"
        }
        /// It cannot find a name
        return "?"
    }
}
