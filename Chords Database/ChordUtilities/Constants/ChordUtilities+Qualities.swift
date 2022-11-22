//
//  ChordUtilities+Qualities.swift
//  Chords Database
//
//  Created by Nick Berendsen on 11/11/2022.
//

import Foundation
import SwiftyChords

extension ChordUtilities {
    
    static var qualities: KeyValuePairs<Chords.Quality, [Int]> {
        // swiftlint:disable duplicated_key_in_dictionary_literal
        [
            
            /// # 'major' chords
            .major: [0, 4, 7],
            /// # 'minor' chords
            .minor: [0, 3, 7],
            
            /// # 'dim' chords
            .dim: [0, 3, 6],
            
            /// # 'dim7' chords
            .dimSeven: [0, 3, 6, 9],
            
            /// # 'sus2' chords
            .susTwo: [0, 2, 7],
            
            /// # 'sus4' chords
            .susFour: [0, 5, 7],
            
            /// # '7sus4' chords
            .sevenSusFour: [0, 5, 7, 10],
            
            /// # 'aug' chords
            .aug: [0, 4, 8],
            
            /// # '6' chords
            .six: [0, 4, 7, 9],
            .six: [0, 4, 9],
            
            /// # '69' chords
            .sixNine: [0, 2, 4, 7, 9],
            .sixNine: [0, 2, 4, 9],
            
            /// # '7' chords
            .seven: [0, 4, 7, 10],
            .seven: [0, 4, 10],
            
            /// # '7b5' chords
            .sevenFlatFive: [0, 4, 6, 10],
            .sevenFlatFive: [0, 4, 10, 18],
            
            /// # 'aug7' chords
            .augSeven: [0, 4, 8, 10],
            
            /// # '7b9' chords
            .sevenFlatNine: [0, 1, 4, 7, 10],
            .sevenFlatNine: [0, 1, 4, 10],
            
            /// # '7#9' chords
            .sevenSharpNine: [0],
            
            /// # '9' chords
            .nine: [0, 2, 4, 7, 10],
            .nine: [0, 2, 4, 10],
            
            /// # '9b5' chords
            .nineFlatFive: [0, 2, 4, 6, 10],
            
            /// # '11' chords
            .eleven: [0, 4, 5, 7, 10],
            .eleven: [0, 4, 5, 10],
            
            /// # '13' chords
            .thirteen: [0, 4, 7, 9, 10],
            .thirteen: [0, 4, 9, 10],
            
            /// # 'Maj7' chords
            .majorSeven: [0, 4, 7, 11],
            
        ]
        // swiftlint:enable duplicated_key_in_dictionary_literal
    }
}
