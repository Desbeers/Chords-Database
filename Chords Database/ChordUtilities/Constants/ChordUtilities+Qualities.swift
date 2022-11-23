//
//  ChordUtilities+Qualities.swift
//  Chords Database
//
//  Created by Nick Berendsen on 11/11/2022.
//

import Foundation
import SwiftyChords

extension ChordUtilities {
    
    /*
     
     0:  R:     Perfect Unison
     1:  m2:    Minor Second
     2:  M2:    Major Second
     3:  m3:    Augmented Second / Minor Third
     4:  M3:    Major Third
     5:  P4:    Perfect Fourth
     6:  A4/d5: Augmented Fourth / Diminished Fifth
     7:  P5:    Perfect Fifth
     8:  A5/m6: Augmented Fifth / Minor Sixth
     9:  M6:    Major Sixth
     10: m7:    Minor Seventh
     11: M7:    Major Seventh
     
     */
    
    static var qualities: KeyValuePairs<Chords.Quality, [Int]> {
        // swiftlint:disable duplicated_key_in_dictionary_literal
        [
            
            /// # 'major' chords
            /*
             Notes: C E G
             Interval structure: R M3 P5
             */
            .major: [0, 4, 7],
            
            /// # 'minor' chords
            /*
             Notes: C Eb G
             Interval structure: R m3 P5
             */
                .minor: [0, 3, 7],
            
            /// # 'dim' chords
            /*
             Notes: C Eb Gb
             Interval structure: R m3 d5
             */
                .dim: [0, 3, 6],
            
            /// # 'dim7' chords
            /*
             Notes: C Eb Gb A
             Interval structure: R m3 d5 M6
             */
                .dimSeven: [0, 3, 6, 9],
            
            /// # 'sus2' chords
            /*
             Notes: C D G
             Interval structure: R M2 P5
             */
                .susTwo: [0, 2, 7],
            
            /// # 'sus4' chords
            /*
             Notes: C F G
             Interval structure: R P4 P5
             */
                .susFour: [0, 5, 7],
            
            /// # '7sus4' chords
            /*
             Notes: C G A# F
             Interval structure: R P4 P5 m7
             */
                .sevenSusFour: [0, 5, 7, 10],
            
            /// # 'aug' chords
            /*
             Notes: C E Ab
             Interval structure: R M3 m6
             */
                .aug: [0, 4, 8],
            
            /// # '6' chords
            /*
             Notes: C E G A
             Interval structure: R M3 M5 M6
             */
                .six: [0, 4, 7, 9],
            /// - Note: The 5th can be omitted
            .six: [0, 4, 9],
            
            /// # '6/9' chords
            /*
             Notes: C E G A D
             Interval structure: R M2 M3 P5 M6
             */
                .sixNine: [0, 2, 4, 7, 9],
            /// - Note: The 5th can be omitted
            .sixNine: [0, 2, 4, 9],
            
            /// # '7' chords
            /*
             Notes: C E G Bb
             Interval structure: R M3 P5 m7
             */
                .seven: [0, 4, 7, 10],
            /// - Note: The 5th can be omitted
            .seven: [0, 4, 10],
            
            /// # '7b5' chords
            /*
             Notes: C E Gb Bb
             Interval structure: R M3 d5 m7
             */
                .sevenFlatFive: [0, 4, 6, 10],
            
            /// # 'aug7' chords
            /*
             Notes: C E G# Bb
             Interval structure: R M3 m6 m7
             */
                .augSeven: [0, 4, 8, 10],
            
            /// # '7b9' chords
            /*
             Notes: C E Bb Db G
             Interval structure: R m2 M3 P5 m7
             */
                .sevenFlatNine: [0, 1, 4, 7, 10],
            /// - Note: The 5th can be omitted
            .sevenFlatNine: [0, 1, 4, 10],
            
            /// # '7#9' chords
            /*
             Notes: C Eb E G Bb
             Interval structure: R m3 M3 P5 M7
             */
                .sevenSharpNine: [0, 3, 4, 7, 10],
            /// - Note: The 5th can be omitted
            .sevenSharpNine: [0, 3, 4, 10],
            
            /// # '9' chords
            /*
             Notes: C E G Bb D
             Interval structure: R M2 M3 P5 m7
             */
                .nine: [0, 2, 4, 7, 10],
            /// - Note: The 5th can be omitted
            .nine: [0, 2, 4, 10],
            
            /// # '9b5' chords
            /*
             Notes: C E Gb Bb D
             Interval structure: R M2 M3 d5 m7
             */
                .nineFlatFive: [0, 2, 4, 6, 10],
            
            /// # '9#11' chords
            /*
             Notes: C D E Gb G Bb
             Interval structure: R  M2 M3 d5 P5 m7
             */
                .nineSharpEleven: [0, 2, 4, 6, 7, 10],
            /// - Note: The 5th can be omitted
            .nineSharpEleven: [0, 2, 4, 6, 10],
            
            /// # '11' chords
            /*
             Notes: C E G Bb D F
             Interval structure: R m2 M3 P4 P5 m7
             */
                .eleven: [0, 2, 4, 5, 7, 10],
            /// - Note: The 2nd can be omitted
            .eleven: [0, 4, 5, 7, 10],
            /// - Note: Both the 2nd and 5th can be omitted
            .eleven: [0, 4, 5, 10],
            
            /// # '13' chords
            /*
             Notes: C E G Bb A
             Interval structure: R M3 P5 M6 m7
             */
                .thirteen: [0, 4, 7, 9, 10],
            /// - Note: The 5th can be omitted
            .thirteen: [0, 4, 9, 10],
            
            /// # 'Maj7' chords
            /*
             Notes: C E G B
             Interval structure: R M3 P5 M7
             */
                .majorSeven: [0, 4, 7, 11],
            
            /// # 'Maj7b5' chords
            /*
             Notes: C E Gb B
             Interval structure: R M3  d5 M7
             */
                .majorSevenFlatFive: [0, 4, 6, 11],
            
            /// # 'Maj7#5' chords
            /*
             Notes: C E Ab E
             Interval structure: R M3 m6 M7
             */
                .majorSevenSharpFive: [0, 4, 8, 11],
            
            /// # 'Maj9' chords
            /*
             Notes: C E G D B
             Interval structure: R M2 M3 P5, M7
             */
                .majorNine: [0, 2, 4, 7, 11],
            /// - Note: The 5th can be omitted
                .majorNine: [0, 2, 4, 11],
            
            /// # 'Maj11' chords
            /*
             Notes: C E G B F
             Interval structure: R M3 P4 P5 M7
             */
                .majorEleven: [0, 4, 5, 7, 11],
            /// - Note: The 5th can be omitted
                .majorEleven: [0, 4, 5, 11],
            
            /// # 'Maj13' chords
            /*
             Notes: C E G B A
             Interval structure: R M3 P5 M6 M7
             */
                .majorThirteen: [0, 4, 7, 9, 11],
            /// - Note: The 5th can be omitted
                .majorThirteen: [0, 4, 9, 11],
            
            /// # 'minor6' chords
            /*
             Notes: C Eb G A
             Interval structure: R m3 P5 M6
             */
                .minorSix: [0, 3, 7, 9],
            
            /// # 'minor6/9' chords
            /*
             Notes: C D D# G A
             Interval structure: R M2 m3 P5 M6
             */
                .minorSixNine: [0, 2, 3, 7, 9],
            /// - Note: The 5th can be omitted
                .minorSixNine: [0, 2, 3, 9],
            
            /// # 'minor7' chords
            /*
             Notes: C Eb G Bb
             Interval structure: R m3 P5 m7
             */
                .minorSeven: [0, 3, 7, 10],
            /// - Note: The 5th can be omitted
                .minorSeven: [0, 3, 10],
            
            /// # 'minor7b5' chords
            /*
             Notes: C Eb Gb Bb
             Interval structure: R m3 d5 m7
             */
                .minorSevenFlatFive: [0, 3, 6, 10],
            
            /// # 'minor9' chords
            /*
             Notes: C Eb G Bb D
             Interval structure: R M2 m3 P5 m7
             */
                .minorNine: [0, 2, 3, 7, 10],
            
            /// # 'minor11' chords
            /*
             Notes: C Eb G Bb F
             Interval structure: R m3 P4 P5 m7
             */
                .minorEleven: [0, 3, 5, 7, 10],
            /// - Note: The 5th can be omitted
                .minorEleven: [0, 3, 5, 10],
            
            /// #'minorMajor7' chord
            /*
             Notes: C Eb G B
             Interval structure: R m3 P5 M7
             */
                .minorMajorSeven: [0, 3, 7, 11],
            
            /// #'minorMajor7b5' chord
            /*
             Notes: C Eb Gb B
             Interval structure: R m3 d5 M7
             */
                .minorMajorSeventFlatFive: [0, 3, 6, 11],
            
            /// #'minorMajor9' chord
            /*
             Notes: C Eb G B D
             Interval structure:
             */
                .minorMajorNine: [0, 2, 3, 7, 11],
            
            /// #'minorMajor11' chord
            /*
             Notes: C Eb G B F
             Interval structure: R m3 P4 P5 M7
             */
                .minorMajorEleven: [0, 3, 5, 7, 11],
            /// - Note: The 5th can be omitted
                .minorMajorEleven: [0, 3, 5, 11],
            
            /// #'add9' chord
            /*
             Notes: C E G D
             Interval structure: R M2 M3 P5
             */
                .addNine: [0, 2, 4, 7],
            
            /// #'minorAdd9' chord
            /*
             Notes: C Eb G D
             Interval structure: R M2 m3 P5
             */
                .minorAddNine: [0, 2, 3, 7]
        ]
        // swiftlint:enable duplicated_key_in_dictionary_literal
    }
}
