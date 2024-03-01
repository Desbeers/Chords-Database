//
//  TemplateView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` to pick a template for a new file
struct TemplateView: View {
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
    /// The dismiss environment
    @Environment(\.dismiss) var dismiss
    /// The body of the `View`
    var body: some View {
        VStack {
            Text("Choose a template for your new database")
                .font(.largeTitle)
            chordDisplayOptions.instrumentPicker
                .pickerStyle(.segmented)
                .labelsHidden()
            image
                .aspectRatio(contentMode: .fit)
                .frame(width: 500)
                .shadow(radius: 10)
            Button("Select") {
                dismiss()
            }
            .padding()
        }
        .padding()
        .animation(.default, value: chordDisplayOptions.instrument)
    }
    /// The instrument image
    var image: some View {
        switch chordDisplayOptions.instrument {
        case .guitarStandardETuning:
            Image(.guitar).resizable()
        case .guitaleleStandardATuning:
            Image(.guitalele).resizable()
        case .ukuleleStandardGTuning:
            Image(.ukulele).resizable()
        }
    }
}
