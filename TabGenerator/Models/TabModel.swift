//
//  Tab.swift
//  TabGenerator
//
//  Created by Мельник Всеволод on 26.05.2023.
//

import Foundation

class TabModel: NSObject, Codable {
    var tuning: Tuning
    var sounds: [[Sound]]

    public init(tuning: Tuning, sounds: [[Sound]]) {
        self.tuning = tuning
        self.sounds = sounds
    }
}
