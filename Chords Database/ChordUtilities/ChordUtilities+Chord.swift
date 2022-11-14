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
        /// Name of the chord. (e.g. C, Am7, F#m7-5/A)
        let chord: String
        /// The root note of the chord. (e.g. C, A, F#)
        let root: String
        /// The quality of the chord. (e.g. maj, m7, m7-5)
        var quality: Quality
        /// The appended notes on the chord
        let appended: [String]
        /// The base note of an optional 'slash' chord
        let on: String
        
        /// # Init
        
        /// Init the chord class
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
        
        /// Return the component notes of chord
        /// - Returns: The notes as [String]
        func components() -> [String] {
            return quality.getComponents(root: root, visible: true)
        }
        
        /// Append the 'on' chord, if any
        private mutating func appendOnChord() {
            if !on.isEmpty {
                quality.appendOnChord(on, root)
            }
        }
    }
}
