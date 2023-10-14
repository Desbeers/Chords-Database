//
//  SharpFlat.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

func sharpFlat(root: Chord.Root) -> Chord.Root? {

    switch root {
    case .cSharp:
        Chord.Root.dFlat
    case .dFlat:
        Chord.Root.cSharp
    case .dSharp:
        Chord.Root.eFlat
    case .eFlat:
        Chord.Root.dSharp
    case .fSharp:
        Chord.Root.gFlat
    case .gFlat:
        Chord.Root.fSharp
    case .gSharp:
        Chord.Root.aFlat
    case .aFlat:
        Chord.Root.gSharp
    case .aSharp:
        Chord.Root.bFlat
    case .bFlat:
        Chord.Root.aSharp
    default:
        nil
    }
}
