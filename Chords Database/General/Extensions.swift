//
//  Extensions.swift
//  Chords Database
//
//  Created by Nick Berendsen on 27/10/2022.
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

extension ChordPosition {
    
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

extension Chords.Key : Comparable {
    /// Implement Comparable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}

extension Chords.Suffix : Comparable {
    /// Implement Comparable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}
