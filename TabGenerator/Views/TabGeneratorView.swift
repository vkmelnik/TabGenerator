//
//  TabGeneratorView.swift
//  TabGenerator
//
//  Created by Мельник Всеволод on 24.05.2023.
//

import UIKit

class TabGeneratorView: UIView {
    private struct Constants {
        static let offset: CGFloat = 10
        static let offsetOffset: CGFloat = 60
        static let offsetSize: CGFloat = 16
        static let noteSize: CGFloat = 32
        static let titleSize: CGFloat = 32
        static let tabFrameHeight: CGFloat = 200
    }

    let title = UITextField()
    let noteLabel = UILabel()
    let offsetLabel = UILabel()
    let tabFrameView = TabFrameView()
    let leftButton = UIButton()
    let rightButton = UIButton()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureTitle()
        configureNote()
        configureTabView()
        configureButtons()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func showNote(string: String, offset: String) {
        noteLabel.text = string
        offsetLabel.text = offset
    }

    private func configureTitle() {
        self.addSubview(title)
        title.pinTop(to: self, Constants.offset)
        title.pinCenterX(to: self)
        title.text = "Песня 1"
        title.font = .systemFont(ofSize: Constants.titleSize)
    }

    private func configureNote() {
        self.addSubview(noteLabel)
        noteLabel.pinCenterX(to: self)
        noteLabel.pinTop(to: title.bottomAnchor, Constants.offset)
        noteLabel.text = "_"
        noteLabel.font = .systemFont(ofSize: Constants.noteSize)

        self.addSubview(offsetLabel)
        offsetLabel.pinCenterX(to: self, Constants.offsetOffset)
        offsetLabel.pinCenterY(to: noteLabel.centerYAnchor)
        offsetLabel.text = ""
        offsetLabel.font = .systemFont(ofSize: Constants.offsetSize)
        offsetLabel.textColor = .gray
    }

    private func configureTabView() {
        self.addSubview(tabFrameView)
        tabFrameView.pinHorizontal(to: self, Constants.offset)
        tabFrameView.pinTop(to: noteLabel.bottomAnchor, Constants.offset)
        tabFrameView.setHeight(Constants.tabFrameHeight)
    }

    private func configureButtons() {
        self.addSubview(leftButton)
        leftButton.pinLeft(to: self, Constants.offset)
        leftButton.pinTop(to: tabFrameView.bottomAnchor, Constants.offset)
        leftButton.setTitle("<--", for: .normal)

        self.addSubview(rightButton)
        rightButton.pinRight(to: self, Constants.offset)
        rightButton.pinTop(to: tabFrameView.bottomAnchor, Constants.offset)
        rightButton.setTitle("-->", for: .normal)
    }
}
