//
//  Note.swift
//  TabGenerator
//
//  Created by Мельник Всеволод on 26.05.2023.
//

import Foundation

enum Sound: Codable {
    case noSound
    case sound(TabSound)

    struct TabSound: Codable {
        let letter: String
        let octave: Int
        let string: Int
        let fret: Int
    }
}
