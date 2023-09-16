//
//  DatabaseView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// The  Database View for Chords
struct DatabaseView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// Chord Display Options
    @EnvironmentObject private var options: ChordDisplayOptions
    /// The conformation dialog to delete a chord
    @State private var confirmationShown = false
    /// The Chords to show in this View
    @State var chords: [ChordDefinition] = []
    /// Bool if we have chords or not
    @State var haveChords = true
    /// The chord for the 'delete' action
    @State private var actionButton: ChordDefinition?

    /// The body of the View
    var body: some View {
        if !haveChords && chords.isEmpty {
            Text("No chords in the key of \(model.selectedRoot?.display.symbol ?? "") found in the datadase")
                .font(.title)
                .padding(.top)
        }
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 260))],
                alignment: .center,
                spacing: 4,
                pinnedViews: [.sectionHeaders, .sectionFooters]
            ) {
                ForEach(chords) { chord in
                    HStack {
                        DiagramView(chord: chord, width: 100)
                        VStack {
                            actions(chord: chord)
                        }
                    }
                    .padding()
                    .background(checkChord(chord: chord) ? Color.accentColor.opacity(0.1) : Color.red.opacity(0.1))
                    .padding()
                }
            }
        }
            .buttonStyle(.bordered)
        .animation(.default, value: haveChords)
        .id(model.selectedRoot)
        .task(id: model.allChords) {
            filterChords()
        }
        .task(id: model.selectedRoot) {
            filterChords()
        }
        .task(id: model.selectedQuality) {
            filterChords()
        }
        .navigationDestination(for: ChordDefinition.self) { chord in
            ChordEditView(chord: chord)
        }
    }

    func checkChord(chord: ChordDefinition) -> Bool {
        let chords = chord.chordFinder
        for match in chords {
            if match.root == chord.root && match.quality == chord.quality {
                return true
            }
        }
        return false
    }

    func filterChords() {
        var allChords = model.allChords.filter { $0.root == model.selectedRoot }
        if let quality = model.selectedQuality {
            allChords = allChords.filter { $0.quality == quality }
        }
        allChords.sort(using: KeyPathComparator(\.root))
        allChords.sort(using: KeyPathComparator(\.quality))
        allChords.sort(using: KeyPathComparator(\.baseFret))
        chords = allChords
        haveChords = chords.isEmpty ? false : true
    }

    func chordFinder(chord: ChordDefinition) -> some View {
        VStack(alignment: .leading) {
            Label(
                chord.chordFinder.isEmpty ? "Found no matching chord" : "Found:",
                systemImage: "waveform.and.magnifyingglass"
            )
            .padding(.vertical, 3)
            HStack {
                ForEach(chord.chordFinder) { result in
                    Text(result.name)
                        .foregroundColor(chord.name == result.name ? .accentColor : .secondary)
                }
            }
            .font(.title3)
        }
    }

    func actions(chord: ChordDefinition) -> some View {
        VStack(alignment: .leading) {

            NavigationLink(value: chord) {
                Label("Edit", systemImage: "square.and.pencil")
            }
            duplicateButton(chord: chord)
            Button(action: {
                actionButton = chord
                confirmationShown = true
            }, label: {
                Label("Delete", systemImage: "trash")
            })
        }
        .labelStyle(ActionLabelStyle())
        .confirmationDialog(
            "Delete \(actionButton?.root.display.accessible ?? "") \(actionButton?.quality.display.accessible ?? "")?",
            isPresented: $confirmationShown,
            titleVisibility: .visible
        ) {
            deleteButton(chord: actionButton)
        } message: {
            Text("With base fret \(actionButton?.baseFret ?? 1000)")
        }
    }

    func editButton(chord: ChordDefinition) -> some View {
        Button(action: {
            model.editChord = chord
        }, label: {
            Label("Edit Chord", systemImage: "square.and.pencil")
        })
    }

    func deleteButton(chord: ChordDefinition?) -> some View {
        Button(action: {
            if let chord, let chordIndex = model.allChords.firstIndex(where: { $0.id == chord.id }) {
                model.allChords.remove(at: chordIndex)
                model.updateDocument.toggle()
            }
        }, label: {
            Text("Delete")
        })
    }

    func duplicateButton(chord: ChordDefinition) -> some View {
        Button(action: {
            let newChord = ChordDefinition(
                id: UUID(),
                name: "Chord",
                frets: chord.frets,
                fingers: chord.fingers,
                baseFret: chord.baseFret,
                root: chord.root,
                quality: chord.quality
            )
            model.editChord = newChord
        }, label: {
            Label("Duplicate", systemImage: "doc.on.doc")
        })
    }

    struct ActionLabelStyle: LabelStyle {
        @Environment(\.sizeCategory) var sizeCategory
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.icon
                    .bold()
                    .frame(width: 16)
                configuration.title
                    .frame(width: 80, alignment: .leading)
            }
        }
    }
}
