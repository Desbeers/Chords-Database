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
    
    /// Singleton class to manage the qualities
    class QualityManager {
        static let shared = QualityManager()
        
        //  var qualities: [String: Quality]
        
        private init() {
//            var qualities: [String: Quality] = [:]
//            for (key, value) in defaultQualities {
//                qualities[key] = Quality(key, value)
//            }
//            self.qualities = qualities
        }
        
//        func loadQualities() {
//            var qualities: [String: Quality] = [:]
//            for (key, value) in defaultQualities {
//                qualities[key] = Quality(key, value)
//            }
//            self.qualities = qualities
//            print("Qualities: \(qualities.count)")
//        }
        
        func getQuality(_ name: String, _ inversion: Int) -> Quality {
            
            guard var quality = defaultQualities.first(where: {$0.key == name}) else {
                return Quality(name, [])
            }

            /// Apply the requested inversion
            for _ in 0..<inversion {
                var component = quality.value[0]
                while component < quality.value.count - 1 {
                    component += 12
                }
                quality.value.append(component)
            }
            return Quality(name, quality.value)
        }
        
        /// Find a quality from components
        /// - Parameter components: Components of quality
        /// - Returns: The quality
        func findQualityFromComponents(components: [Int]) -> String {
            
            for quality in defaultQualities where quality.value == components {
                return quality.key
            }
            print(components)
            //  for quality in qualities.values where quality.components == components {
//            for quality in qualities.values where quality.components == components {
//                //print(quality.quality)
//                return quality.quality
//            }
            return ""
        }
    }
}
