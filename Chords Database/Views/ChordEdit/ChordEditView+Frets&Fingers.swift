//
//  ChordEditView+Frets&Fingers.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

extension ChordEditView {
    var fretsAndFingers: some View {
        VStack {
            Section(
                content: {
                    options.fretsPicker
                    .pickerStyle(StaticSetting.pickerStyle)
                }, header: {
                    header(text: "Frets")
                })
            Section(
                content: {
                    options.fingersPicker
                    .pickerStyle(StaticSetting.pickerStyle)
                }, header: {
                    header(text: "Fingers")
                })
        }
    }
}
