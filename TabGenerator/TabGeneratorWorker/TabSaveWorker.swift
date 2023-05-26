//
//  TabSaveWorker.swift
//  TabGenerator
//
//  Created by Мельник Всеволод on 26.05.2023.
//

import Foundation
import UIKit

class TabSaveWorker {
    public static var shared = TabSaveWorker()

    public func save(name: String, tab: TabModel) {
        let file = name + ".txt"

        let text = getText(name: name, from: tab)

        do {
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                        in: .userDomainMask).first {
                let pathWithFilename = documentDirectory.appendingPathComponent(file)
                try text.write(to: pathWithFilename,
                                    atomically: true,
                                    encoding: .utf8)
                showFolder(documentDirectory: documentDirectory)
            }
        } catch {
            print("Unable to save tabs.")
        }
    }

    private func showFolder(documentDirectory: URL) {
        let path = documentDirectory.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
        let url = URL(string: path)!

        UIApplication.shared.open(url)
    }

    private func getText(name: String, from tab: TabModel) -> String {
        let tuning = tab.tuning.getTuning()
        var text = name + "\n" + "Tuning: " + tuning.string6 + " " + tuning.string5 + " " + tuning.string4 + " " + tuning.string3 + " " + tuning.string2 + " " + tuning.string1 + "\n\n"
        for i in 0...tab.sounds.count / 16 {
            for string in 0...5 {
                for j in 0...15 {
                    if tab.sounds.count > i * 16 + j {
                        switch tab.sounds[i * 16 + j][string] {
                        case .noSound:
                            text.append("--")
                        case.sound(let sound):
                            text.append(formatFret(sound.fret))
                        }
                    }
                }
                text.append("\n")
            }
            text.append("\n")
        }

        text.append("")

        return text
    }

    private func formatFret(_ fret: Int) -> String {
        let fret = String(fret)
        if fret.count == 1 {
            return fret + "-"
        } else {
            return fret
        }
    }
}
