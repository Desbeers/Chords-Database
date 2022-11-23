//
//  ChordFinder+Chord.swift
//  Chords Database
//
//  Created by Nick Berendsen on 11/11/2022.
//

import Foundation
import SwiftyChords

extension ChordUtilities {
    
    /// Struct to handle a chord
    struct Chord: Identifiable {
        
        /// # Properties
        
        /// The ID of the chord
        var id: String {
            chord
        }
        /// The chord in the UI
        var display: String {
            var display = "\(root.display.symbol)"
            if quality.name != .major {
                display += " \(quality.name.display.symbolized)"
            }
            if let on {
                display += Chords.Suffix(rawValue: "/\(on.rawValue)")?.display.symbolized ?? "/?"
            }
            return display
        }
        /// The name of the chord, as found
        var name: String {
            var name = root.rawValue
            if let on {
                name += "/\(on.rawValue)"
            } else {
                name += quality.name.rawValue
            }
            return name
        }
        /// Name of the chord. (e.g. C, Am7, F#m7-5/A)
        let chord: String
        /// The root note of the chord. (e.g. C, A, F#)
        let root: Chords.Root
        /// The quality of the chord. (e.g. maj, m7, m7-5)
        var quality: Quality
        /// The appended notes on the chord
        let appended: [String]
        /// The base note of an optional 'slash' chord
        let on: Chords.Root?
        
        /// # Init
        
        /// Init the chord struct from a string
        init(chord: String) {
            /// Parse the chord string
            let parse = ChordUtilities.parse(chord: chord)
            /// Set the properties
            self.chord = chord
            self.root = parse.root
            self.quality = parse.quality
            self.appended = parse.appended
            self.on = parse.on
            /// Append optional 'slash' chord
            self.appendOnChord()
        }
        
        /// Init the chord with known components
        init(chord: String, root: Chords.Root, quality: Quality, on: Chords.Key? = nil) {
            self.chord = chord
            self.root = root
            self.quality = quality
            self.appended = []
            self.on = on
        }
        
        /// # Fuctions
        
        /// Return the component notes of chord
        /// - Returns: The notes as [String]
        func components() -> [Chords.Key] {
            return quality.getComponents(root: root, visible: true)
        }
        
        /// Append the 'on' chord, if any
        private mutating func appendOnChord() {
            if let on {
                quality.appendOnChord(on, root)
            }
        }
    }
}
