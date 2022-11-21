//
//  ChordUtilities+Scales.swift
//  Chords Database
//
//  Created by Nick Berendsen on 11/11/2022.
//

import Foundation
import SwiftyChords

extension ChordUtilities {
    
    static var noterValueDict: [Chords.Root: Int] {
        [
            Chords.Root.c: 0,
            Chords.Root.cSharp: 1,
            Chords.Root.dFlat: 1,
            Chords.Root.d: 2,
            Chords.Root.dSharp: 3,
            Chords.Root.eFlat: 3,
            Chords.Root.e: 4,
            Chords.Root.f: 5,
            Chords.Root.fSharp: 6,
            Chords.Root.gFlat: 6,
            Chords.Root.g: 7,
            Chords.Root.gSharp: 8,
            Chords.Root.aFlat: 8,
            Chords.Root.a: 9,
            Chords.Root.aSharp: 10,
            Chords.Root.bFlat: 10,
            Chords.Root.b: 11
        ]
    }

    static var valueNoteDict: [Int: [Chords.Root]] {
        [
            0: [Chords.Root.c],
            1: [Chords.Root.dFlat, Chords.Root.cSharp],
            2: [Chords.Root.d],
            3: [Chords.Root.eFlat, Chords.Root.dSharp],
            4: [Chords.Root.e],
            5: [Chords.Root.f],
            6: [Chords.Root.fSharp, Chords.Root.gFlat],
            7: [Chords.Root.g],
            8: [Chords.Root.aFlat, Chords.Root.gSharp],
            9: [Chords.Root.a],
            10: [Chords.Root.bFlat, Chords.Root.aSharp],
            11: [Chords.Root.b]
        ]
    }
    
    static var sharpedScale: [Int: Chords.Root] {
        [
            0: Chords.Root.c,
            1: Chords.Root.cSharp,
            2: Chords.Root.d,
            3: Chords.Root.dSharp,
            4: Chords.Root.e,
            5: Chords.Root.f,
            6: Chords.Root.fSharp,
            7: Chords.Root.g,
            8: Chords.Root.gSharp,
            9: Chords.Root.a,
            10: Chords.Root.aSharp,
            11: Chords.Root.b
        ]
    }

    static var flattedScale: [Int: Chords.Root] {
        [
            0: Chords.Root.c,
            1: Chords.Root.dFlat,
            2: Chords.Root.d,
            3: Chords.Root.eFlat,
            4: Chords.Root.e,
            5: Chords.Root.f,
            6: Chords.Root.gFlat,
            7: Chords.Root.g,
            8: Chords.Root.aFlat,
            9: Chords.Root.a,
            10: Chords.Root.bFlat,
            11: Chords.Root.b
        ]
    }
    
    static var scaleValueDict: [Chords.Root: [Int: Chords.Root]] {
        [
            Chords.Root.aFlat: flattedScale,
            Chords.Root.a: sharpedScale,
            Chords.Root.aSharp: sharpedScale,
            Chords.Root.bFlat: flattedScale,
            Chords.Root.b: sharpedScale,
            Chords.Root.c: flattedScale,
            Chords.Root.cSharp: sharpedScale,
            Chords.Root.dFlat: flattedScale,
            Chords.Root.d: sharpedScale,
            Chords.Root.dSharp: sharpedScale,
            Chords.Root.eFlat: flattedScale,
            Chords.Root.e: sharpedScale,
            Chords.Root.f: flattedScale,
            Chords.Root.fSharp: sharpedScale,
            Chords.Root.gFlat: flattedScale,
            Chords.Root.g: sharpedScale,
            Chords.Root.gSharp: sharpedScale
        ]
    }
}
