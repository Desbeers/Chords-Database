//
//  TemplateView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

struct TemplateView: View {
    /// Chord Display Options
    @EnvironmentObject private var options: ChordDisplayOptions
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Text("Choose a template for your new database")
                .font(.largeTitle)
            options.instrumentPicker
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
        .animation(.default, value: options.instrument)
    }
    /// The instrument image
    var image: some View {
        switch options.instrument {
        case .guitarStandardETuning:
            Image(.guitar).resizable()
        case .guitaleleStandardATuning:
            Image(.guitalele).resizable()
        case .ukuleleStandardGTuning:
            Image(.ukulele).resizable()
        }
    }
}
