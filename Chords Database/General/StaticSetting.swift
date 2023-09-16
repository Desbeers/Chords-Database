//
//  StaticSetting.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI

enum StaticSetting {

#if os(macOS)

    static let sidebarColumnWidth: Double = 100

    static let rootListStyle = InsetListStyle(alternatesRowBackgrounds: true)

    static let pickerStyle = RadioGroupPickerStyle()

#endif

#if os(iOS)

    static let sidebarColumnWidth: Double = 200

    static let rootListStyle = InsetGroupedListStyle()

    static let pickerStyle = WheelPickerStyle()

#endif
}
