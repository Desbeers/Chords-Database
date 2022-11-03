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
    @State var kays: [Chords.Key] = []
    /// The body of the View
    var body: some View {
        List(selection: $model.selectedKey) {
            ForEach(model.allChords.unique { $0.key }) { key in
                Text(key.key.display.symbol)
                    .tag(key.key)
            }
        }
        .onChange(of: model.selectedKey) { _ in
            model.selectedSuffix = nil
        }
    }
}
