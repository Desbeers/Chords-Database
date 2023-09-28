//
//  DatabaseView.swift
//  Chords Database
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` for the database
struct DatabaseView: View {
    /// The SwiftUI model for the Chords Database
    @EnvironmentObject var model: ChordsDatabaseModel
    /// Chord Display Options
    @EnvironmentObject private var options: ChordDisplayOptions
    /// The conformation dialog to delete a chord
    @State private var showDeleteConfirmation = false
    /// The Chords to show in this View
    @State var chords: [ChordDefinition] = []
    /// Bool if we have chords or not
    @State var haveChords = true
    /// The chord for the 'delete' action
    @State private var actionButton: ChordDefinition?
    /// The body of the `View`
    var body: some View {
        if !haveChords && chords.isEmpty {
            // swiftlint:disable:next line_length
            Text("No chords in the key of \(model.selectedRoot?.display.symbol ?? "") found in the \(model.instrument.label) Database")
                .font(.title)
                .padding(.top)
        }
        ScrollView {
            if model.instrument == .ukuleleStandardGTuning {
                // swiftlint:disable:next line_length
                Label("For Ukulele chords, the first note is often not the base chord. With only 4 strings, I leave them as they are", systemImage: "info.circle.fill")
                    .padding()
            }
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 220))],
                alignment: .center,
                spacing: 4,
                pinnedViews: [.sectionHeaders, .sectionFooters]
            ) {
                ForEach(chords) { chord in
                    VStack {
                        HStack {
                            DiagramView(chord: chord, width: 150)
                            VStack {
                                actions(chord: chord)
                            }
                        }
                        Text(chord.validate.label)
                            .font(.caption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.2)
                    }
                    .padding()
                    .background(chord.validate.color.opacity(0.1))
                    .padding()
                }
                if let root = model.selectedRoot, root != Chord.Root.none {
                    Button(
                        action: {
                            if let newChord = ChordDefinition(definition: root.rawValue, instrument: model.instrument) {
                                options.definition = newChord
                                model.navigationStack.append(newChord)
                            }
                        }, label: {
                            Text("Add a new **\(root.display.symbol)** chord")
                        }
                    )
                }
            }
            .padding()
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

    /// Filter the chords
    private func filterChords() {
        var allChords: [ChordDefinition] = []
        if model.selectedRoot == Chord.Root.none {
            allChords = model.allChords
        } else {
            allChords = model.allChords.filter { $0.root == model.selectedRoot }
        }
        if let quality = model.selectedQuality {
            allChords = allChords.filter { $0.quality == quality }
        }
        chords = allChords
        haveChords = chords.isEmpty ? false : true
    }

    /// Chord actions
    private func actions(chord: ChordDefinition) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            editButton(chord: chord)
            duplicateButton(chord: chord)
            confirmDeleteButton(chord: chord)
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.plain)
        .font(.largeTitle)
        .confirmationDialog(
            "Delete \(actionButton?.root.display.accessible ?? "") \(actionButton?.quality.display.accessible ?? "")?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            deleteButton(chord: actionButton)
        } message: {
            Text("With base fret \(actionButton?.baseFret ?? 1000)")
        }
    }

    // MARK: Action Buttons

    /// Edit chord button
    private func editButton(chord: ChordDefinition) -> some View {
        Button(
            action: {
                options.definition = chord
                model.navigationStack.append(chord)
            },
            label: {
                Label("Edit", systemImage: "square.and.pencil")
            }
        )
    }

    /// Duplicate chord button
    private func duplicateButton(chord: ChordDefinition) -> some View {
        Button(
            action: {
                var duplicate = chord
                duplicate.id = UUID()
                options.definition = duplicate
                model.navigationStack.append(duplicate)
            },
            label: {
                Label("Duplicate", systemImage: "doc.on.doc")
            }
        )
    }

    /// Confirm chord delete button
    private func confirmDeleteButton(chord: ChordDefinition) -> some View {
        Button(
            action: {
                actionButton = chord
                showDeleteConfirmation = true
            },
            label: {
                Label("Delete", systemImage: "trash")
            }
        )
    }

    /// Delete chord button
    private func deleteButton(chord: ChordDefinition?) -> some View {
        Button(
            action: {
                if let chord, let chordIndex = model.allChords.firstIndex(where: { $0.id == chord.id }) {
                    model.allChords.remove(at: chordIndex)
                    model.updateDocument.toggle()
                }
            },
            label: {
                Text("Delete")
            }
        )
    }
}
