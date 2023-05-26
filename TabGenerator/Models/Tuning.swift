//
//  Tuning.swift
//  TabGenerator
//
//  Created by Мельник Всеволод on 26.05.2023.
//

import Foundation

struct CustomTuning: Codable {
    let string1: String
    let string2: String
    let string3: String
    let string4: String
    let string5: String
    let string6: String

    public init(_ notes: [String]) {
        string1 = notes[5]
        string2 = notes[4]
        string3 = notes[3]
        string4 = notes[2]
        string5 = notes[1]
        string6 = notes[0]
    }
}

enum Tuning: Codable {
    case standart
    case custom(CustomTuning)

    func getTuning() -> CustomTuning {
        switch self {
        case .standart:
            return  CustomTuning(["E2", "A2", "D3", "G3", "B3", "E4"])
        case .custom(let tuning):
            return tuning
        }
    }
}
