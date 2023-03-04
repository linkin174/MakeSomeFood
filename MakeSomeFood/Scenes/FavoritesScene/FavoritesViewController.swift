//
//  FavoritesViewController.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 28.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FavoritesDisplayLogic: AnyObject {
    func displaySomething(viewModel: FavoritesList.ShowFavorites.ViewModel)
}

final class FavoritesViewController: UIViewController, FavoritesDisplayLogic {

    // MARK: - Public Properties

    var interactor: FavoritesBusinessLogic?
    var router: (FavoritesRoutingLogic & FavoritesDataPassing)?

    // MARK: - Private Properties

    private var viewModel: FavoritesList.ShowFavorites.ViewModel?

    // MARK: - Views

    let topMaskView = TopMaskView(fillColor: .mainAccentColor)

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let itemSide = view.bounds.width / 2 - layout.minimumInteritemSpacing * 1.5
        layout.itemSize = CGSize(width: itemSide, height: itemSide)

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .backGroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.reuseID)
        return collectionView
    }()

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        FavoritesConfigurator.shared.configure(with: self)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        FavoritesConfigurator.shared.configure(with: self)
        setupConstraints()
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupNavigationBar()
        setupTabBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onLoad()
    }

    // MARK: - Private Methods


    func onLoad() {
        interactor?.start()
    }

    func displaySomething(viewModel: FavoritesList.ShowFavorites.ViewModel) {
        self.viewModel = viewModel
        collectionView.reloadData()
    }

    private func setupNavigationBar() {
        let appearence = UINavigationBarAppearance()
        appearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearence.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearence.backgroundColor = .mainAccentColor
        appearence.shadowColor = nil
        let titleView = UILabel()
        titleView.text = "Favorites"
        titleView.font = .handlee(of: 40)
        titleView.textColor = .mainTintColor
        navigationItem.titleView = titleView
        navigationItem.compactAppearance = appearence
        navigationItem.standardAppearance = appearence
        navigationItem.scrollEdgeAppearance = appearence
    }

    private func setupTabBar() {
        tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 1)
    }

    private func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(topMaskView)
        topMaskView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(16)
        }
    }
}

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.routeToRecipeDetails()
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.cells.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.reuseID, for: indexPath) as? RecipeCell else { return UICollectionViewCell() }
        if let cellVM = viewModel?.cells[indexPath.item] {
            cell.viewModel = cellVM
        }
        return cell
    }

}
