//
//  ChordFinder+Utils.swift
//  Chords Database
//
//  Created by Nick Berendsen on 12/11/2022.
//

import Foundation

extension ChordUtilities {

    /// Get index value of a note
    static func noteToValue(note: String) -> Int {
        guard let value = noterValueDict[note] else {
            return 0
        }
        return value
    }
    
    /// Return note by index in a scale
    static func valueToNote(value: Int, scale: String = "C") -> String {
        let value = value < 0 ? (12 % value) : (value % 12)
        guard let value = scaleValueDict[scale]?[value] else {
            return ""
        }
        return value
    }
}
