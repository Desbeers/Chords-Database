//
//  DiagramView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

struct DiagramView: View {
    init(chord: ChordDefinition, width: Double, instrument: Instrument = .guitarStandardETuning) {
//        if tuning == .guitarStandardETuning {
//            self.chord = chord
//        } else {
//            self.chord = Self.transposeChord(chord: chord, tuning: tuning)
//        }
        self.chord = chord
        self.width = width
    }
    
    let chord: ChordDefinition
    let width: Double

    /// Chord Display Options
    @EnvironmentObject private var options: ChordDisplayOptions

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        //Text(chord.instrument.rawValue)
        ChordDefinitionView(chord: chord, width: width, options: options.displayOptions)
            .frame(height: width * 1.6)
            .foregroundStyle(Color.primary, colorScheme == .dark ? .black : .white)
            .animation(.default, value: options.displayOptions)
            .animation(.default, value: options.definition)
    }

//    static func transposeChord(chord: ChordDefinition, tuning: Tuning) -> ChordDefinition {
//
//        var newFrets: [Int] = []
//
//        for string in tuning.strings {
//            var stringValue = chord.frets[string]
//            //let newValue = stringValue == - 1 ? stringValue : (stringValue + 2)
//            switch string {
//            case 0, 1, 5:
//                newFrets.append(stringValue == -1 ? stringValue : (stringValue + 2))
//            default:
//                newFrets.append(stringValue)
//            }
//        }
//
//        return ChordDefinition(
//            id: chord.id,
//            name: chord.name,
//            frets: newFrets,
//            fingers: chord.fingers,
//            baseFret: chord.baseFret,
//            root: chord.root,
//            quality: chord.quality, 
//            bass: chord.bass,
//            tuning: tuning,
//            status: chord.status
//        )
//    }
}
