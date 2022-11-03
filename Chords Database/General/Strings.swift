//
//  Strings.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK: Guitar Strings

/// The strings on the guitar
enum Strings: Int, CaseIterable {
    // swiftlint:disable identifier_name
    case E
    case A
    case D
    case G
    case B
    case e
    // swiftlint:enable identifier_name
    
    /// The offset for each string from the base 'E'
    ///  - Note: Start with -1, because of the BaseFret value in `ChordPosition`
    var offset: Int {
        switch self {
        case .E:
            return -1
        case .A:
            return 4
        case .D:
            return 9
        case .G:
            return 14
        case .B:
            return 18
        case .e:
            return 23
        }
    }
}
