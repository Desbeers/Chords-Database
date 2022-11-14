//
//  Chords+Suffix+pattern.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftyChords

extension Chords.Suffix {

    var pattern: [Int] {
        switch self {

        case .major:
            return [0, 4]
        case .minor:
            return [0, 3]
        case .dim:
            return [0, 3, 6]
        case .dimSeven:
            return [0, 3, 6, 9]
        case .susTwo:
            return [0, 2]
        case .susFour:
            return [0, 5]
        case .sevenSusFour:
            return [0, 5, 10]
        case .altered:
            return [0, 4, 6]
        case .aug:
            return [0, 4, 8]
        case .six:
            return [0, 4, 9]
        case .sixNine:
            return [0, 2, 4, 9]
        case .seven:
            return [0, 4, 10]
        case .sevenFlatFive:
            return [0, 4, 6, 10]
        case .augSeven:
            return [0, 4, 8, 10]
        case .nine:
            return [0, 2, 4, 10]
        case .nineFlatFive:
            return [0, 2, 4, 6, 10]
        case .augNine:
            return [0, 2, 4, 8, 10]
        case .sevenFlatNine:
            return [0, 1, 4, 10]
        case .sevenSharpNine:
            return [0, 3, 4, 10]
        case .eleven:
            return [0, 4, 5, 10]
        case .nineSharpEleven:
            return [0, 2, 4, 6, 10]
        case .thirteen:
            return [0, 4, 9, 10]
        case .majorSeven:
            return [0, 4, 11]
        case .majorSevenFlatFive:
            return [0, 4, 6, 11]
        case .majorSevenSharpFive:
            return [0, 4, 8, 11]
        case .majorNine:
            return [0, 2, 4, 11]
        case .majorEleven:
            return [0, 4, 5, 11]
        case .majorThirteen:
            return [0, 4, 9, 11]
        case .minorSix:
            return [0, 3, 9]
        case .minorSixNine:
            return [0, 2, 3, 9]
        case .minorSeven:
            return [0, 3, 10]
        case .minorSevenFlatFive:
            /// 7(b5) is just an alternative notation for a 7(#11) chord. 7(#11) is the recommended notation.
            return [0, 3, 6, 10]
        case .minorNine:
            return [0, 2, 3, 10]
        case .minorEleven:
            return [3, 4, 6, 9, 11]
        case .minorMajorSeven:
            return [0, 1, 4, 8, 9]
        case .minorMajorSeventFlatFive:
            /// I have no clue...
            return [0]
        case .minorMajorNine:
            /// I have no clue...
            return [0]
        case .minorMajorEleven:
            /// I have no clue...
            return [0]
        case .addNine:
            return [0, 2, 4]
        case .minorAddNine:
            return [0, 2, 3]
        case .slashE:
            return [7, 0, 4]
        case .slashF:
            return [0]
        case .slashFSharp:
            return [0]
        case .slashG:
            return [0]
        case .slashGSharp:
            return [0]
        case .slashA:
            return [0]
        case .slashBFlat:
            return [0]
        case .slashB:
            return [0]
        case .slashC:
            return [0]
        case .slashCSharp:
            return [0]
        case .minorSlashB:
            return [0]
        case .minorSlashC:
            return [0]
        case .minorSlashCSharp:
            return [0]
        case .slashD:
            return [0]
        case .minorSlashD:
            return [0]
        case .slashDSharp:
            return [0]
        case .minorSlashDSharp:
            return [0]
        case .minorSlashE:
            return [0]
        case .minorSlashF:
            return [0]
        case .minorSlashFSharp:
            return [0]
        case .minorSlashG:
            return [0]
        case .minorSlashGSharp:
            return [0]
        }
    }
}
