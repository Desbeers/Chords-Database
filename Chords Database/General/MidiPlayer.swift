//
//  MidiPlayer.swift
//  Chords Database
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import AudioToolbox
import SwiftyChords

/// Play a chord with its MIDI values
class MidiPlayer {
    /// Make it a shared class
    static let shared = MidiPlayer()
    /// A private init because it is 'shared
    private init() {}
    /// The music player that plays a music sequence
    var musicPlayer: MusicPlayer?
    /// The music sequence
    var sequence: MusicSequence?
    /// The music track to play
    var track: MusicTrack?
    /// The player status
    var player: OSStatus?
    /// The music track status
    var musicTrack: OSStatus?
}

extension MidiPlayer {

    /// Play a chord with its MIDI values
    /// - Parameters:
    ///   - notes: The notes to play
    ///   - instument: The ``Instrument`` to use
    func playNotes(notes: [Int], instument: Instrument = .acousticNylonGuitar) async {
        var time = MusicTimeStamp(1.0)
        _ = NewMusicSequence(&self.sequence)
        /// The amount f strings to play
        let strings = notes.count - 1
        /// Letup the player
        self.player = NewMusicPlayer(&self.musicPlayer)
        self.player = MusicPlayerSetSequence(self.musicPlayer!, self.sequence)
        self.player = MusicPlayerStart(self.musicPlayer!)
        self.musicTrack = MusicSequenceNewTrack(self.sequence!, &self.track)
        /// Set the instrument to use
        var inMessage = MIDIChannelMessage(status: 0xC0, data1: UInt8(instument.rawValue), data2: 0, reserved: 0)
        MusicTrackNewMIDIChannelEvent(self.track!, 0, &inMessage)
        /// Add the notes to the track
        for index: Int in 0...strings {
            var note = MIDINoteMessage(channel: 0,
                                       note: UInt8(notes[index]),
                                       velocity: 127,
                                       releaseVelocity: 0,
                                       duration: Float(Double(strings) - time + 3))
            guard let track = self.track else {fatalError()}
            self.musicTrack = MusicTrackNewMIDINoteEvent(track, time, &note)
            time += 0.1
        }
        /// Set the sequence
        self.player = MusicPlayerSetSequence(self.musicPlayer!, self.sequence)
        /// Play the chord
        self.player = MusicPlayerStart(self.musicPlayer!)
    }
}

extension MidiPlayer {

    /// The available MIDI instruments
    enum Instrument: Int, CaseIterable {
        case acousticNylonGuitar = 24
        case acousticSteelGuitar
        case electricJazzGuitar
        case electricCleanGuitar
        case electricMutedGuitar
        case overdrivenGuitar
        case distortionGuitar

        //// The label for the instrument
        var label: String {
            switch self {
            case .acousticNylonGuitar:
                return "Acoustic Nylon Guitar"
            case .acousticSteelGuitar:
                return "Acoustic Steel Guitar"
            case .electricJazzGuitar:
                return "Electric Jazz Guitar"
            case .electricCleanGuitar:
                return "Electric Clean Guitar"
            case .electricMutedGuitar:
                return "Electric Muted Guitar"
            case .overdrivenGuitar:
                return "Overdriven Guitar"
            case .distortionGuitar:
                return "Distortion Guitar"
            }
        }
    }
}

extension MidiPlayer {

    /// SwiftUI Button to play the chord with MIDI
    struct PlayButton: View {
        /// The chord to play
        let chord: ChordPosition
        /// The selected MIDI instrument
        @AppStorage("MIDI instrument") private var instrument: MidiPlayer.Instrument = .acousticNylonGuitar
        /// The body of the View
        var body: some View {
            Button(action: {
                chord.play(instrument: instrument)
            }, label: {
                Label("Play", systemImage: "play.fill")
            })
        }
    }
}

extension MidiPlayer {

    /// SwiftUI Picker to select a MIDI instrument
    struct InstrumentPicker: View {
        /// The MIDI instrument
        @AppStorage("MIDI instrument") private var midiInstrument: MidiPlayer.Instrument = .acousticNylonGuitar
        /// The body of the View
        var body: some View {
            Picker("Instrument:", selection: $midiInstrument) {
                ForEach(MidiPlayer.Instrument.allCases, id: \.rawValue) { value in
                    Text(value.label)
                        .tag(value)
                }
            }
        }
    }
}
