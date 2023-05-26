//
//  TabGeneratorWorkerLogic.swift
//  TabGenerator
//
//  Created by Мельник Всеволод on 26.05.2023.
//

import Foundation

protocol TabGeneratorLogic {
    func getTabSound(note: String, octave: Int) -> Sound
}
