//
//  ChordUtilities+Scales.swift
//  Chords Database
//
//  Created by Nick Berendsen on 11/11/2022.
//

import Foundation
import SwiftyChords

extension ChordUtilities {
    
    static var noterValueDict: [Chords.Key: Int] {
        [
            Chords.Key.c: 0,
            Chords.Key.cSharp: 1,
            Chords.Key.dFlat: 1,
            Chords.Key.d: 2,
            Chords.Key.dSharp: 3,
            Chords.Key.eFlat: 3,
            Chords.Key.e: 4,
            Chords.Key.f: 5,
            Chords.Key.fSharp: 6,
            Chords.Key.gFlat: 6,
            Chords.Key.g: 7,
            Chords.Key.gSharp: 8,
            Chords.Key.aFlat: 8,
            Chords.Key.a: 9,
            Chords.Key.aSharp: 10,
            Chords.Key.bFlat: 10,
            Chords.Key.b: 11,
        ]
    }

    static var valueNoteDict: [Int: [Chords.Key]] {
        [
            0: [Chords.Key.c],
            1: [Chords.Key.dFlat, Chords.Key.cSharp],
            2: [Chords.Key.d],
            3: [Chords.Key.eFlat, Chords.Key.dSharp],
            4: [Chords.Key.e],
            5: [Chords.Key.f],
            6: [Chords.Key.fSharp, Chords.Key.gFlat],
            7: [Chords.Key.g],
            8: [Chords.Key.aFlat, Chords.Key.gSharp],
            9: [Chords.Key.a],
            10: [Chords.Key.bFlat, Chords.Key.aSharp],
            11: [Chords.Key.b]
        ]
    }
    
    static var sharpedScale: [Int: Chords.Key] {
        [
            0: Chords.Key.c,
            1: Chords.Key.cSharp,
            2: Chords.Key.d,
            3: Chords.Key.dSharp,
            4: Chords.Key.e,
            5: Chords.Key.f,
            6: Chords.Key.fSharp,
            7: Chords.Key.g,
            8: Chords.Key.gSharp,
            9: Chords.Key.a,
            10: Chords.Key.aSharp,
            11: Chords.Key.b
        ]
    }

    static var flattedScale: [Int: Chords.Key] {
        [
            0: Chords.Key.c,
            1: Chords.Key.dFlat,
            2: Chords.Key.d,
            3: Chords.Key.eFlat,
            4: Chords.Key.e,
            5: Chords.Key.f,
            6: Chords.Key.gFlat,
            7: Chords.Key.g,
            8: Chords.Key.aFlat,
            9: Chords.Key.a,
            10: Chords.Key.bFlat,
            11: Chords.Key.b
        ]
    }
    
    static var scaleValueDict: [Chords.Key: [Int: Chords.Key]] {
        [
            Chords.Key.aFlat: flattedScale,
            Chords.Key.a: sharpedScale,
            Chords.Key.aSharp: sharpedScale,
            Chords.Key.bFlat: flattedScale,
            Chords.Key.b: sharpedScale,
            Chords.Key.c: flattedScale,
            Chords.Key.cSharp: sharpedScale,
            Chords.Key.dFlat: flattedScale,
            Chords.Key.d: sharpedScale,
            Chords.Key.dSharp: sharpedScale,
            Chords.Key.eFlat: flattedScale,
            Chords.Key.e: sharpedScale,
            Chords.Key.f: flattedScale,
            Chords.Key.fSharp: sharpedScale,
            Chords.Key.gFlat: flattedScale,
            Chords.Key.g: sharpedScale,
            Chords.Key.gSharp: sharpedScale
        ]
    }
}
