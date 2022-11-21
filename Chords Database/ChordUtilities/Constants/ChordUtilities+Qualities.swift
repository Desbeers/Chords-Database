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
            .major: [0, 7, 16],
            
            /// # 'minor' chords
            .minor: [0, 3, 7],
            .minor: [0, 7, 15],
            
            /// # 'dim' chords
            .dim: [0, 3, 6],
            .dim: [0, 6, 15],
            
            /// # 'dim7' chords
            .dimSeven: [0, 3, 6, 9],
            .dimSeven: [0, 6, 9, 15],
            .dimSeven: [0, 6, 15, 21],
            .dimSeven: [0, 9, 15, 18],
            
            /// # 'sus2' chords
            .susTwo: [0, 2, 7],
            .susTwo: [0, 7, 14],
            
            /// # 'sus4' chords
            .susFour: [0, 5, 7],
            .susFour: [0, 7, 17],
            
            /// # '7sus4' chords
            .sevenSusFour: [0, 5, 7, 10],
            .sevenSusFour: [0, 7, 10, 17],
            
            /// # 'aug' chords
            .aug: [0, 4, 8],
            .aug: [0, 8, 16],
            
            /// # '6' chords
            .six: [0, 4, 7, 9],
            .six: [0, 4, 9],
            .six: [0, 7, 9, 16],
            .six: [0, 7, 16, 21],
            .six: [0, 9, 16, 19],
            
            /// # '69' chords
            .sixNine: [0, 2, 4, 7, 9],
            .sixNine: [0, 2, 4, 9],
            .sixNine: [0, 2, 7, 16, 21],
            .sixNine: [0, 2, 9, 16],
            .sixNine: [0, 4, 7, 9, 14],
            .sixNine: [0, 4, 9, 14, 19],
            .sixNine: [0, 4, 9, 14],
            .sixNine: [0, 9, 14, 16],
            .sixNine: [0, 7, 14, 16, 21],
            
            /// # '7' chords
            .seven: [0, 4, 7, 10],
            .seven: [0, 4, 10],
            .seven: [0, 4, 10, 19],
            .seven: [0, 7, 10, 16],
            .seven: [0, 7, 16, 22],
            
            /// # '7b5' chords
            .sevenFlatFive: [0, 4, 6, 10],
            .sevenFlatFive: [0, 4, 10, 18],
            .sevenFlatFive: [0, 6, 10, 16],
            .sevenFlatFive: [0, 6, 16, 22],
            .sevenFlatFive: [0, 10, 16, 18],
            
            /// # '7b9' chords
            .sevenFlatNine: [0, 1, 4, 7, 10],
            .sevenFlatNine: [0, 1, 4, 10],
            .sevenFlatNine: [0, 4, 7, 13, 22],
            .sevenFlatNine: [0, 4, 10, 13],
            .sevenFlatNine: [0, 4, 10, 13, 19],
            .sevenFlatNine: [0, 7, 10, 16, 25],
            .sevenFlatNine: [0, 7, 13, 16, 22],
            .sevenFlatNine: [0, 10, 13, 16],
            .sevenFlatNine: [0, 10, 16, 19, 25],
            .sevenFlatNine: [0, 10, 19, 25, 28],
            
            /// # '9' chords
            .nine: [0, 2, 4, 7, 10],
            .nine: [0, 2, 4, 10],
            .nine: [0, 2, 7, 16, 22],
            .nine: [0, 4, 10, 14],
            .nine: [0, 4, 7, 10, 14],
            .nine: [0, 4, 10, 14, 19],
            .nine: [0, 7, 10, 14, 16],
            .nine: [0, 7, 10, 16, 26],
            .nine: [0, 7, 14, 16, 22],
            .nine: [0, 7, 16, 22],
            
            /// # '11' chords
            .eleven: [0, 4, 5, 7, 10],
            .eleven: [0, 4, 5, 10],
            .eleven: [0, 4, 10, 17],
            .eleven: [0, 4, 17, 22],
            .eleven: [0, 5, 7, 16, 22],
            .eleven: [0, 5, 10, 16],
            .eleven: [0, 5, 10, 16, 19],
            
            /// # '13' chords
            .thirteen: [0, 4, 7, 9, 10],
            .thirteen: [0, 4, 10, 21],
            .thirteen: [0, 4, 10, 14, 21],
            .thirteen: [0, 4, 10, 19, 21],
            .thirteen: [0, 7, 10, 16, 21],
            .thirteen: [0, 10, 16, 21],
            
            /// # 'Maj7' chords
            .majorSeven: [0, 4, 7, 11],
            .majorSeven: [0, 7, 11, 16],
            .majorSeven: [0, 7, 16, 23],
            .majorSeven: [0, 11, 16, 19]
            
        ]
        // swiftlint:enable duplicated_key_in_dictionary_literal
    }
}
