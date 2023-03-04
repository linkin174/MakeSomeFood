//
//  RecipesViewController.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import SnapKit
import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayRecipes(viewModel: RecipesList.DisplayRecipes.ViewModel)
    func displayError(viewModel: RecipesList.HandleError.ViewModel)
}

class RecipesViewController: UIViewController, HomeDisplayLogic {
    var interactor: RecipesBuisnessLogic?
    var router: (RecipesRoutingLogic & RecipesDataPassing)?

    // MARK: - Private properties

    private var isLoadingNext = false

    private var viewModel: RecipesList.DisplayRecipes.ViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - Views

    private let topMaskView = TopMaskView(fillColor: .mainAccentColor)

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .mainAccentColor
        indicator.hidesWhenStopped = true
        return indicator
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let itemSide = view.bounds.width / 2 - layout.minimumInteritemSpacing * 1.5
        layout.itemSize = CGSize(width: itemSide, height: itemSide)

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .backGroundColor
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.reuseID)
        return collectionView
    }()

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        RecipesConfigurator.shared.configure(with: self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        RecipesConfigurator.shared.configure(with: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupConstraints()
        start()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
        setupNavigationBar()
    }

    // MARK: - Private methods

    private func setupNavigationBar() {
        title = "Recipes"
        let appearence = UINavigationBarAppearance()
        appearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearence.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearence.backgroundColor = .mainAccentColor
        appearence.shadowColor = nil

        navigationItem.compactAppearance = appearence
        navigationItem.scrollEdgeAppearance = appearence
        navigationItem.standardAppearance = appearence

        let titleView = UILabel()
        titleView.text = "Recipes"
        titleView.font = .handlee(of: 40)
        titleView.textColor = .mainTintColor
        navigationItem.titleView = titleView

        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(showFilters))
        searchButton.tintColor = .white
        navigationItem.rightBarButtonItem = searchButton
    }

    private func setupTabBar() {
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.barTintColor = .mainAccentColor
        tabBarController?.tabBar.tintColor = .mainTintColor
        tabBarController?.tabBar.backgroundColor = .mainAccentColor
        tabBarController?.tabBar.unselectedItemTintColor = .disabledColor
        tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
    }

    private func setupConstraints() {
        view.addSubview(topMaskView)
        view.addSubview(loadingIndicator)

        topMaskView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
            make.top.equalTo(view.snp.topMargin)
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func start() {
        loadingIndicator.startAnimating()
        interactor?.viewDidLoad()
    }

    private func loadNextRecipes() {
        if !isLoadingNext {
            interactor?.loadNextRecipes()
        }
        isLoadingNext = true
    }

    @objc private func showFilters() {
        router?.presentFilters()
    }

    // MARK: - Display Logic

    func displayRecipes(viewModel: RecipesList.DisplayRecipes.ViewModel) {
        DispatchQueue.main.async { [unowned self] in
            self.viewModel = viewModel
            loadingIndicator.stopAnimating()
            isLoadingNext = false
        }
    }

    func displayError(viewModel: RecipesList.HandleError.ViewModel) {
        showAlert(title: "Something went wrong", message: viewModel.errorMessage)
    }
}

// MARK: - Extensions

extension RecipesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.routeToRecipeDetails()
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        #warning("think about this check due to next link in interactor is nil so it may not be needed")
        guard !(viewModel?.cells.isEmpty ?? false) else { return }
        if scrollView.contentSize.height - scrollView.frame.height - 300 <= scrollView.contentOffset.y {
            loadNextRecipes()
        }
    }
}

extension RecipesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.cells.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.reuseID,
                                                          for: indexPath) as? RecipeCell
        else {
            return UICollectionViewCell()
        }
        if let cellVM = viewModel?.cells[indexPath.item] {
            cell.viewModel = cellVM
        }
        return cell
    }
}

extension RecipesViewController: FiltersViewControllerDelegate {
    func reloadRecipies() {
        viewModel = nil
        start()
    }
}
