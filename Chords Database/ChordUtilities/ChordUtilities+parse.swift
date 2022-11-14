//
//  ChordFinder+parse.swift
//  Chords Database
//
//  Created by Nick Berendsen on 11/11/2022.
//

import Foundation
import SwiftyChords

extension ChordUtilities {
    
    /// Parse a string to get chord component
    /// - Parameter chord: Expression of a chord
    /// - Returns: (root, quality, appended, on)
    static func parse(chord: String) -> (root: String, quality: Quality, appended: [String], on: String) {
        
        var root: String = ""
        let appended: [String] = []
        var on: String = ""
        
        var rest: String = ""
        
        if let chordMatch = chord.wholeMatch(of: chordRegex) {
            /// Set the root
            root = String(chordMatch.1)
            /// Set the suffix, if any
            if let matchSuffix = chordMatch.2 {
                rest = String(matchSuffix)
            }
        }
        
        func checkNote(note: String) {
            guard noterValueDict[note] != nil else {
                return
            }
        }
        
        checkNote(note: root)
        
        var inversion = 0
        
        if let inversionMatch = rest.wholeMatch(of: inversionRegex) {
            inversion = Int(inversionMatch.1) ?? 0
            rest = String(inversionMatch.2)
        }
        
        if rest.firstIndex(of: "/") != nil {
            let split = rest.split(separator: "/", omittingEmptySubsequences: false)
            rest = String(split.first ?? "")
            on = String(split.last ?? "")
            checkNote(note: on)
        }

        let quality = QualityManager.shared.getQuality(rest, inversion)
        
        return (root, quality, appended, on)
    }
}
