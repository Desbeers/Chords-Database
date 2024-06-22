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
    @Environment(ChordsDatabaseModel.self) private var chordsDatabaseModel
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
    /// The conformation dialog to delete a chord
    @State private var showDeleteConfirmation = false
    /// The Chords to show in this View
    @State var chords: [ChordDefinition] = []
    /// The Chords to show in this View
    @State var flatSharpChords: [ChordDefinition] = []
    /// Bool if we have chords or not
    @State var haveChords = true
    /// The chord for the 'delete' action
    @State private var actionButton: ChordDefinition?
    /// The body of the `View`
    var body: some View {
        let sharpFlat = sharpFlat(root: chordsDatabaseModel.selection.root ?? .none)
        if !haveChords && chords.isEmpty {
            // swiftlint:disable:next line_length
            Text("No chords in the key of \(chordsDatabaseModel.selection.root?.display.symbol ?? "") found in the \(chordsDatabaseModel.instrument.label) Database")
                .font(.title)
                .padding(.top)
        }
        if chordsDatabaseModel.instrument == .ukuleleStandardGTuning {
            // swiftlint:disable:next line_length
            Label("For Ukulele chords, the first note is often not the base chord. With only 4 strings, I leave them as they are", systemImage: "info.circle.fill")
                .padding()
        }
        GeometryReader { geometry in
            ScrollView {
                HStack(alignment: .top) {
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
                                Text(chord.validate.description)
                                    .font(.caption)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.2)
                            }
                            .padding()
                            .background(chord.validate.color.opacity(0.1))
                            .padding()
                        }
                        if let root = chordsDatabaseModel.selection.root, root != Chord.Root.none {
                            Button(
                                action: {
                                    if let newChord = ChordDefinition(
                                        name: root.rawValue,
                                        instrument: chordsDatabaseModel.instrument
                                    ) {
                                        chordDisplayOptions.definition = newChord
                                        chordsDatabaseModel.navigationStack.append(newChord)
                                    }
                                }, label: {
                                    Text("Add a new **\(root.display.symbol)** chord")
                                }
                            )
                        }
                    }
                    .padding()
                    .frame(width: sharpFlat != nil ? geometry.size.width / 2 : geometry.size.width)
                    if sharpFlat != nil {
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 220))],
                            alignment: .center,
                            spacing: 4,
                            pinnedViews: [.sectionHeaders, .sectionFooters]
                        ) {
                            ForEach(flatSharpChords) { chord in
                                VStack {
                                    HStack {
                                        DiagramView(chord: chord, width: 150)
                                        VStack {
                                            actions(chord: chord)
                                        }
                                    }
                                    Text(chord.validate.description)
                                        .font(.caption)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.2)
                                }
                                .padding()
                                .background(chord.validate.color.opacity(0.05))
                                .padding()
                            }
                        }
                        .padding()
                        .frame(width: geometry.size.width / 2)
                        .background(.thickMaterial)
                    }
                }
                .frame(maxHeight: .infinity)
            }
        }
        .buttonStyle(.bordered)
        .animation(.default, value: haveChords)
        .id(chordsDatabaseModel.selection)
        .task(id: chordsDatabaseModel.allChords) {
            filterChords()
        }
        .task(id: chordsDatabaseModel.selection) {
            filterChords()
        }
        .navigationDestination(for: ChordDefinition.self) { chord in
            ChordEditView(chord: chord)
        }
    }

    /// Filter the chords
    private func filterChords() {
        var allChords: [ChordDefinition] = []
        if chordsDatabaseModel.selection.root == Chord.Root.none {
            allChords = chordsDatabaseModel.allChords
        } else {
            allChords = chordsDatabaseModel.allChords.filter { $0.root == chordsDatabaseModel.selection.root }
        }
        if let quality = chordsDatabaseModel.selection.quality {
            allChords = allChords.filter { $0.quality == quality }
        }
        if let bass = chordsDatabaseModel.selection.bass {
            allChords = allChords.filter { $0.bass == bass }
        }
        chords = allChords.sorted(using: [
            KeyPathComparator(\.bass)
        ])
        haveChords = chords.isEmpty ? false : true

        /// Sharp and Flats
        if let sharpFlat = sharpFlat(root: chordsDatabaseModel.selection.root ?? .none) {
            allChords = chordsDatabaseModel.allChords.filter { $0.root == sharpFlat }
            if let quality = chordsDatabaseModel.selection.quality {
                allChords = allChords.filter { $0.quality == quality }
            }
            if let bass = chordsDatabaseModel.selection.bass {
                allChords = allChords.filter { $0.bass == bass }
            }
            flatSharpChords = allChords.sorted(using: [
                KeyPathComparator(\.bass)
            ])
        }
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
                chordDisplayOptions.definition = chord
                chordsDatabaseModel.navigationStack.append(chord)
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
                chordDisplayOptions.definition = duplicate
                chordsDatabaseModel.navigationStack.append(duplicate)
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
                if let chord, let chordIndex = chordsDatabaseModel.allChords.firstIndex(where: { $0.id == chord.id }) {
                    chordsDatabaseModel.allChords.remove(at: chordIndex)
                    chordsDatabaseModel.updateDocument.toggle()
                }
            },
            label: {
                Text("Delete")
            }
        )
    }
}
