//
//  ChordUtilities+Scales.swift
//  Chords Database
//
//  Created by Nick Berendsen on 11/11/2022.
//

import Foundation

extension ChordUtilities {
    
    static var noterValueDict: [String: Int] {
        [
            "Ab": 8,
            "A": 9,
            "A#": 10,
            "Bb": 10,
            "B": 11,
            "Cb": 11,
            "C": 0,
            "C#": 1,
            "Db": 1,
            "D": 2,
            "D#": 3,
            "Eb": 3,
            "E": 4,
            "F": 5,
            "F#": 6,
            "Gb": 6,
            "G": 7,
            "G#": 8
        ]
    }
    
    static var valueNoteDict: [Int: [String]] {
        [
            0: ["C"],
            1: ["Db", "C#"],
            2: ["D"],
            3: ["Eb", "D#"],
            4: ["E"],
            5: ["F"],
            6: ["F#", "Gb"],
            7: ["G"],
            8: ["Ab", "G#"],
            9: ["A"],
            10: ["Bb", "A#"],
            11: ["B", "Cb"]
        ]
    }
    
    static var sharpedScale: [Int: String] {
        [
            0: "C",
            1: "C#",
            2: "D",
            3: "D#",
            4: "E",
            5: "F",
            6: "F#",
            7: "G",
            8: "G#",
            9: "A",
            10: "A#",
            11: "B"
        ]
    }

    static var flattedScale: [Int: String] {
        [
            0: "C",
            1: "Db",
            2: "D",
            3: "Eb",
            4: "E",
            5: "F",
            6: "Gb",
            7: "G",
            8: "Ab",
            9: "A",
            10: "Bb",
            11: "B"
        ]
    }
    
    static var scaleValueDict: [String: [Int: String]] {
        [
            "Ab": flattedScale,
            "A": sharpedScale,
            "A#": sharpedScale,
            "Bb": flattedScale,
            "B": sharpedScale,
            "Cb": flattedScale,
            "C": flattedScale,
            "C#": sharpedScale,
            "Db": flattedScale,
            "D": sharpedScale,
            "D#": sharpedScale,
            "Eb": flattedScale,
            "E": sharpedScale,
            "F": flattedScale,
            "F#": sharpedScale,
            "Gb": flattedScale,
            "G": sharpedScale,
            "G#": sharpedScale
        ]
    }
}
