//
//  MainView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

struct MainView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// Chord Display Options
    @EnvironmentObject private var options: ChordDisplayOptions
    var body: some View {
        NavigationSplitView(
            sidebar: {
                HStack(spacing: 0) {
                    SidebarView()
                    Divider()
                    RootDetailsView()
                }
                .navigationBarBackButtonHidden()
            }, detail: {
                NavigationStack(path: $model.navigationStack) {
                    DatabaseView()
#if !os(macOS)
                        .navigationBarBackButtonHidden()
#endif
                }
            }
        )
        .navigationTitle("Chords Database")
        .toolbar {
            options.mirrorButton
            options.tuningPicker
            options.instrumentPicker
            /// New Chord Button
            Button(action: {
                let chord = ChordDefinition(
                    id: UUID(),
                    name: "New",
                    frets: [0, 0, 0, 0, 0, 0],
                    fingers: [0, 0, 0, 0, 0, 0],
                    baseFret: 1,
                    root: .c,
                    quality: .major,
                    tuning: options.displayOptions.tuning,
                    status: .standard
                )
                model.navigationStack.append(chord)
            }, label: {
                Label("New Chord", systemImage: "plus")
            })
            .disabled(!model.navigationStack.isEmpty)
            .labelStyle(.iconOnly)
        }
    }
}
