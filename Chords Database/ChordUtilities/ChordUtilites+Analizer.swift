//
//  ChordUtilites+Analizer.swift
//  Chords Database
//
//  Created by Nick Berendsen on 13/11/2022.
//

import Foundation
import SwiftyChords

extension ChordUtilities {
    
    /// Get info about a chord
    /// - Parameters:
    ///   - key: The root of the chord
    ///   - suffix: The quality of the chord
    /// - Returns: A ``Chord``
    static func getChordInfo(root: Chords.Root, quality: Chords.Quality) -> Chord {
        return Chord(chord: root.rawValue + quality.enumToString)
    }

    /// Find possible chords consisted from notes
    /// - Parameter notes: List of note arranged from lower note. ex ["C", "Eb", "G"]
    /// - Returns: A ``Chord``array
    static func findChordsFromNotes(notes: [Chords.Key]) -> [Chord] {
        if notes.isEmpty {
            return []
        }
        
        let root = notes[0]
        var rootAndPositions: [Chords.Root: [Int]] = [:]
        
        for rotatedNotes in getAllRotatedNotes(notes: notes) {
            let rotatedRoot = rotatedNotes[0]
            rootAndPositions[rotatedRoot] = notesToPositions(notes: rotatedNotes, root: rotatedRoot)
        }
        
//        for rotatedNotes in getAllRotatedNotes(notes: notes) {
//            let rotatedRoot = rotatedNotes[0]
//            var notes: [Int] = []
//            let notePositions = notesToPositions(notes: rotatedNotes, root: Chords.Root(rawValue: rotatedRoot) ?? .c)
//            for note in notePositions {
//                notes.append(note % 12)
//            }
//            rootAndPositions[rotatedRoot] = notes.sorted()
//        }
        
        
        //dump(rootAndPositions)
        var chords: [Chord] = []
        for (tempRoot, positions) in rootAndPositions {
            if let quality = findQualityFromComponents(components: positions) {
                var chord: String = ""
                var on: Chords.Key?
                if tempRoot == root {
                    chord = "\(root)\(quality.name.enumToString)"
                } else {
                    on = root
                    chord = "\(tempRoot)\(quality.name.enumToString)/\(root)"
                }
                //chords.append(Chord(chord: chord))
                chords.append(Chord(chord: chord, root: tempRoot, quality: quality, on: on))
            }
        }
        return chords
    }

    /// Get all rotated notes
    ///
    /// [A,C,E]) -> [[A,C,E],[C,E,A],[E,A,C]]
    ///
    /// - Parameter notes: The list of notes
    /// - Returns: The possible chords
    static func getAllRotatedNotes(notes: [Chords.Key]) -> [[Chords.Key]] {
        var notesList: [[Chords.Key]] = []
        for index in 0..<notes.count {
            notesList.append(Array(notes[index...] + notes[..<index]))
        }

        print("----")
        //print(notesList)
        return notesList
    }

    /// Get notes positions from the root note
    /// - Parameters:
    ///   - notes: List of notes
    ///   - root: Root note
    /// - Returns: List of note positions
    static func notesToPositions(notes: [Chords.Key], root: Chords.Root) -> [Int] {
        
        let rootPosition = ChordUtilities.noteToValue(note: root)
        
        var currentPosition = rootPosition
        var positions: [Int] = []
        
        for note in notes {
            var notePostion = ChordUtilities.noteToValue(note: note)
            if notePostion < currentPosition {
                notePostion += 12 * ((currentPosition - notePostion) / 12 + 1)
            }
//            /// Check if the notePosition is inverted
//            if (notePostion - rootPosition) > 12 && notes.count == 3 {
//                notePostion -= 12
//            }
            positions.append(notePostion - rootPosition)
            currentPosition = notePostion
        }
        //print(positions)
        return positions
    }
}
