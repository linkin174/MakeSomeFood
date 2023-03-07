//
//  RecipeCollectionView.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 06.03.2023.
//

import UIKit

final class RecipeCollectionView: UICollectionView {

    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let itemSide = UIScreen.main.bounds.width / 2 - layout.minimumInteritemSpacing * 1.5
        layout.itemSize = CGSize(width: itemSide, height: itemSide)
        return layout
    }()

    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        showsVerticalScrollIndicator = false
        backgroundColor = .mainBackgroundColor
        register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.reuseID)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
