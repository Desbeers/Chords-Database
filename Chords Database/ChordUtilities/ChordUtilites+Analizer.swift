//
//  ChordUtilites+Analizer.swift
//  Chords Database
//
//  Created by Nick Berendsen on 13/11/2022.
//

import Foundation
import Algorithms

extension ChordUtilities {

    /// Find possible chords consisted from notes
    /// - Parameter notes: List of note arranged from lower note. ex ["C", "Eb", "G"]
    /// - Returns: A ``Chord``array
    static func findChordsFromNotes(notes: [String]) -> [Chord] {
        if notes.isEmpty {
            return []
        }
        
        let root = notes[0]
        var rootAndPositions: [String: [Int]] = [:]
        
        for rotatedNotes in getAllRotatedNotes(notes: notes) {
            let rotatedRoot = rotatedNotes[0]
            var notes: [Int] = []
            let notePositions = notesToPositions(notes: rotatedNotes, root: rotatedRoot)
            for note in notePositions {
                notes.append(note % 12)
            }
            rootAndPositions[rotatedRoot] = notes.sorted()
        }
        
        var chords: [Chord] = []
        
        for (tempRoot, positions) in rootAndPositions {
            let quality = QualityManager.shared.findQualityFromComponents(components: positions)
            var chord: String = ""
            print(positions)
            if quality.isEmpty {
                continue
            }
            if tempRoot == root {
                chord = "\(root)\(quality)"
            } else {
                chord = "\(tempRoot)\(quality)/\(root)"
            }

            chords.append(Chord(chord: chord))
        }
        
        return chords
    }

    /// Get all rotated notes
    ///
    /// [A,C,E]) -> [[A,C,E],[C,E,A],[E,A,C]]
    ///
    /// - Parameter notes: The list of notes
    /// - Returns: The possible chords
    static func getAllRotatedNotes(notes: [String]) -> [[String]] {
        var notesList: [[String]] = []
        
        for perm in notes.permutations() {
            notesList.append(perm)
        }

//        for index in 0..<notes.count {
//            notesList.append(Array(notes[index...] + notes[..<index]))
//        }

        print("----")
        print(notesList)
        return notesList
    }

    /// Get notes positions from the root note
    /// - Parameters:
    ///   - notes: List of notes
    ///   - root: Root note
    /// - Returns: List of note positions
    static func notesToPositions(notes: [String], root: String) -> [Int] {
        
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
        return positions
    }
}
