//
//  SoundCell.swift
//  TabGenerator
//
//  Created by Мельник Всеволод on 26.05.2023.
//

import UIKit

class SoundCell: UICollectionViewCell {
    private struct Constants {
        static let size: CGFloat = 16
    }

    public static let reuseIdentifier = "SoundCell"

    var fret: Int = 0
    let numberLabel: UILabel = UILabel()
    let string: UIView = UIView()
    let isPlayed: UIView = UIView()

    public func configureUI() {
        self.addSubview(string)
        string.backgroundColor = UIColor(white: 0.5, alpha: 0.4)
        string.pinCenterY(to: self)
        string.pinHorizontal(to: self)
        string.setHeight(2)

        self.addSubview(isPlayed)
        isPlayed.backgroundColor = .clear
        isPlayed.pinCenterX(to: self)
        isPlayed.pinVertical(to: self)
        isPlayed.setWidth(4)

        self.addSubview(numberLabel)
        numberLabel.pinCenter(to: self)
        numberLabel.text = ""
        numberLabel.font = .systemFont(ofSize: Constants.size)
    }

    public func play() {
        isPlayed.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
    }
}
