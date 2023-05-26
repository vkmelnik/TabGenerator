//
//  TabFrameView.swift
//  TabGenerator
//
//  Created by Мельник Всеволод on 26.05.2023.
//

import UIKit

class TabFrameView: UIView {
    var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        // layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        return layout
    }

    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), collectionViewLayout: layout)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.addSubview(collectionView)
        collectionView.pin(to: self)
        collectionView.register(SoundCell.self, forCellWithReuseIdentifier: SoundCell.reuseIdentifier)
    }
}
