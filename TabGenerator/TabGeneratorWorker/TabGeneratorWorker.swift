//
//  TabGeneratorWorker.swift
//  TabGenerator
//
//  Created by Мельник Всеволод on 26.05.2023.
//

import Foundation

class TabGeneratorWorker: TabGeneratorLogic {
    public static var shared = TabGeneratorWorker(tuning: .standart)

    private let tuning: Tuning
    private let scale = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

    public init(tuning: Tuning) {
        self.tuning = tuning
    }

    public func getTabSound(note: String, octave: Int) -> Sound {
        var octave = octave

        if octave > 4 {
            octave -= 2
        }

        if octave < 2 {
            octave += 1
        }

        var fret = getNumber(note: note + String(octave)) - getNumber(note: tuning.getTuning().string6)
        var string = 6

        if (fret < 0) {
            return Sound.noSound
        }

        if (fret > 6) {
            string = 5
            fret = getNumber(note: note + String(octave)) - getNumber(note: tuning.getTuning().string5)
        }

        if (fret > 6) {
            string = 4
            fret = getNumber(note: note + String(octave)) - getNumber(note: tuning.getTuning().string4)
        }

        if (fret > 6) {
            string = 3
            fret = getNumber(note: note + String(octave)) - getNumber(note: tuning.getTuning().string3)
        }

        if (fret > 6) {
            string = 2
            fret = getNumber(note: note + String(octave)) - getNumber(note: tuning.getTuning().string2)
        }

        if (fret > 6) {
            string = 1
            fret = getNumber(note: note + String(octave)) - getNumber(note: tuning.getTuning().string1)
        }

        return Sound.sound(.init(letter: note, octave: octave, string: string, fret: fret))
    }

    private func getNumber(note: String) -> Int {
        let octave = Int(note.suffix(1)) ?? 1
        let number = scale.firstIndex(of: String(note.prefix(2))) ?? (scale.firstIndex(of: String(note.prefix(1))) ?? 0)

        return 12 * octave + number
    }
}
