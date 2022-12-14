//
//  SidebarView.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftyChords

/// The  Sidebar View
struct SidebarView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// The Keys to show in this View
    @State var kays: [Chords.Root] = []
    /// The body of the View
    var body: some View {
        List(selection: $model.selectedRoot) {
            ForEach(Chords.Root.allCases, id: \.rawValue) { key in
                Text(key.display.symbol)
                    .tag(key)
            }
        }
        .onChange(of: model.selectedRoot) { _ in
            model.selectedQuality = nil
        }
    }
}
