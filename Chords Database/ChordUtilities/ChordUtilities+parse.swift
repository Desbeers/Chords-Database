//
//  ChordFinder+parse.swift
//  Chords Database
//
//  Created by Nick Berendsen on 11/11/2022.
//

import Foundation
import SwiftyChords

extension ChordUtilities {
    
    /// Parse a chord string to get chord components
    /// - Parameter chord: Expression of a chord
    /// - Returns: (root, quality, appended, on)
    static func parse(chord: String) -> (root: Chords.Root, quality: Quality, appended: [String], on: Chords.Root?) {
        
        var root: String = ""
        let appended: [String] = []
        var on: Chords.Root?
        
        var rest: String = ""
        var inversion = 0
        
        if let chordMatch = chord.wholeMatch(of: chordRegex) {
            /// Set the root
            root = String(chordMatch.1)
            /// Set the suffix, if any
            if let matchSuffix = chordMatch.2 {
                rest = String(matchSuffix)
            }
        }

        if let inversionMatch = rest.wholeMatch(of: inversionRegex) {
            inversion = Int(inversionMatch.1) ?? 0
            rest = String(inversionMatch.2)
        }
        
        if rest.firstIndex(of: "/") != nil {
            let split = rest.split(separator: "/", omittingEmptySubsequences: false)
            rest = String(split.first ?? "")
            on = Chords.Root(rawValue: String(split.last ?? ""))
        }
        
        rest = rest.isEmpty ? "major" : rest
        
        let lookup = Chords.Quality.stringToEnum(string: rest)

        let quality = getQualityFromChord(name: lookup, inversion: inversion)
        
        return (Chords.Root.stringToEnum(string: root),
                quality,
                appended,
                on
        )
    }
}
