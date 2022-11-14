//
//  ChordFinder+Regex.swift
//  Chords Database
//
//  Created by Nick Berendsen on 11/11/2022.
//

import Foundation
import RegexBuilder

extension ChordUtilities {
    
    /// The regex for a `chord` string
    ///
    /// It will parse the chord to find the `kay` and optional `suffix`
    ///
    ///     /// ## Examples
    ///
    ///     Am -> key: Am, suffix: nil
    ///     Dsus4 -> key: D, suffix: sus4
    ///
    static let chordRegex = Regex {
        /// The Key
        Capture {
            OneOrMore {
                CharacterClass(
                    .anyOf("CDEFGABb#")
                )
            }
        }
        /// The optional Suffix
        Optionally {
            Capture {
                OneOrMore(.any)
            }
        }
    }
    
    static let inversionRegex = Regex {
        "/"
        Capture {
            OneOrMore(("0"..."9"))
        }
        Capture {
            ZeroOrMore(.any)
        }
    }
    
//    static let inversionRegex = Regex {
//        /// The inversion
//        Capture {
//            OneOrMore(("0"..."9"))
//        }
//        /// The rest
//        Capture {
//            OneOrMore(.any)
//        }
//    }
    
    static let slashRegex = Regex {
        /// The slash
        Capture {
            OneOrMore("/")
        }
        /// The following chord
        Capture {
            OneOrMore(.any)
        }
    }
}
