//
//  ChordFinder+Quality.swift
//  Chords Database
//
//  Created by Nick Berendsen on 11/11/2022.
//

import Foundation

extension ChordUtilities {
    
    /// The chord quality
    struct Quality {
        /// Name of quality
        var quality: String
        /// Components of quality
        var components: [Int]
        /// Init the quality
        init(_ name: String, _ components: [Int]) {
            self.quality = name
            self.components = components
        }
        
        /// Get components of chord quality
        /// - Parameters:
        ///   - root: The root note of the chord
        ///   - visible: Returns the name of notes if True
        /// - Returns: Components of chord quality
        func getComponents(root: String, visible: Bool = true) -> [String] {
            let intComponents = getIntComponents(root: root)
            var components: [String] = []
            for component in intComponents {
                components.append(valueToNote(value: component, scale: root))
            }
            return components
        }
        
        private func getIntComponents(root: String) -> [Int] {
            let rootValue = noteToValue(note: root)
            var components: [Int] = []

            for component in self.components {
                components.append(component + rootValue)
            }
            return components
        }
        
        /// Append on chord
        ///
        /// To create Am7/G
        /// q = Quality('m7')
        /// q.append_on_chord('G', root='A')
        ///
        /// - Parameters:
        ///   - onChord: Bass note of the chord
        ///   - root: Root note of the chord
        mutating func appendOnChord(_ onChord: String, _ root: String) {
            /// Get the value of the root note
            let rootValue = noteToValue(note: root)
            /// Get the value of the 'on' note
            let onChordValue = noteToValue(note: onChord) - rootValue
            /// Start with the current components
            var components = self.components
            /// Remove the 'on' note from the components, if it is included
            for (index, value) in self.components.enumerated() where (value % 12) == onChordValue {
                    components.remove(at: index)
                    break
            }
            /// Add the bass note
            components.insert(onChordValue, at: 0)
            /// Update the components with the new values
            self.components = components
        }
    }
    
    /// Enum with functions to manage the qualities
    enum QualityManager {

        /// Get the quality of a chord
        /// - Parameters:
        ///   - name: The name of the chotds
        ///   - inversion: The inversion
        /// - Returns: A ``ChordUtilities/Quality``
        static func getQualityFromChord(chord: String, inversion: Int) -> Quality {
            
            guard var quality = defaultQualities.first(where: {$0.key == chord}) else {
                return Quality(chord, [])
            }

            /// Apply the requested inversion
            for _ in 0..<inversion {
                var component = quality.value[0]
                while component < quality.value.count - 1 {
                    component += 12
                }
                quality.value.append(component)
            }
            return Quality(chord, quality.value)
        }
        
        /// Get a quality from chord components
        /// - Parameter components: Components of quality
        /// - Returns: The quality
        static func getQualityFromComponents(components: [Int]) -> String {
            for quality in defaultQualities where quality.value == components {
                return quality.key
            }
            return ""
        }
    }
}
