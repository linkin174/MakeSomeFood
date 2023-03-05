//
//  RecipeDetailsViewController.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import SafariServices
import SnapKit
import UIKit

protocol RecipeDetailsDisplayLogic: AnyObject {
    func displayRecipeDetails(viewModel: RecipeDetails.ShowRecipeDetails.ViewModel)
    func displayFavoriteState(viewModel: RecipeDetails.SetFavoriteState.ViewModel)
}

final class RecipeDetailsViewController: UIViewController, RecipeDetailsDisplayLogic {
    // MARK: - Public Properties

    var interactor: RecipeDetailsBusinessLogic?
    var router: (RecipeDetailsRoutingLogic & RecipeDetailsDataPassing)?

    // MARK: - Private propertis

    private var viewModel: RecipeDetails.ShowRecipeDetails.ViewModel?

    // MARK: - Views

    private let topMaskView = TopMaskView(fillColor: .mainAccentColor)

    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .backGroundColor
        scrollView.bounces = true
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()

    private lazy var nutritionFactsView: NutritionFactsView = {
        let view = NutritionFactsView()
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(hideNutritionFacts))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(swipeGesture)
        return view
    }()

    private let recipeImageView: CachedUIImageView = {
        let imageView = CachedUIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let recipeTitleLabel = UILabel.makeUILabel(font: .systemFont(ofSize: 20, weight: .bold),
                                                       textColor: .mainTextColor,
                                                       alignment: .left)

    private let ingiridientsLabel = UILabel.makeUILabel(text: "List of ingridients:",
                                                        font: .systemFont(ofSize: 18, weight: .semibold),
                                                        textColor: .mainTextColor)

    private let totalNutrientsLabel = UILabel.makeUILabel(text: "Total Nutrients:",
                                                          font: .systemFont(ofSize: 18, weight: .semibold),
                                                          textColor: .mainTextColor)

    private let ingridientsStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()

    private lazy var showSafariViewButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
        button.setTitle("Cooking Details", for: .normal)
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.backgroundColor = .mainAccentColor
        button.addTarget(self, action: #selector(showSafariView), for: .touchUpInside)
        button.dropShadow()
        return button
    }()

    private lazy var showNutritionFactsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "tablecells.badge.ellipsis"), for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .mainAccentColor
        button.addTarget(self, action: #selector(showNutritionFacts), for: .touchUpInside)
        button.imageView?.tintColor = .white
        button.dropShadow()
        return button
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .mainAccentColor
        button.dropShadow()
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        RecipesDetailsConfigurator.shared.configure(with: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        RecipesDetailsConfigurator.shared.configure(with: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupNavigationBar()
        start()
    }

    // MARK: - Private methods

    private func setupNavigationBar() {
        let appearence = UINavigationBarAppearance()
        appearence.backgroundColor = .mainAccentColor
        appearence.shadowColor = nil
        appearence.shadowImage = nil

        navigationController?.navigationBar.tintColor = .mainTintColor

        navigationItem.compactAppearance = appearence
        navigationItem.scrollEdgeAppearance = appearence
        navigationItem.standardAppearance = appearence
        navigationItem.backBarButtonItem?.tintColor = .mainTintColor
    }

    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(recipeImageView)
        recipeImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(scrollView.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }

        recipeImageView.addSubview(showSafariViewButton)
        showSafariViewButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        recipeImageView.addSubview(showNutritionFactsButton)
        showNutritionFactsButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }

        recipeImageView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.leading.equalTo(showNutritionFactsButton.snp.trailing).offset(8)
            make.bottom.equalTo(showNutritionFactsButton.snp.bottom)
            make.width.height.equalTo(40)
        }

        scrollView.addSubview(recipeTitleLabel)
        recipeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeImageView.snp.bottom).offset(8)
            make.width.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }

        scrollView.addSubview(ingiridientsLabel)
        ingiridientsLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
        }

        scrollView.addSubview(ingridientsStack)
        ingridientsStack.snp.makeConstraints { make in
            make.top.equalTo(ingiridientsLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(16)
            make.width.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }

        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.bottom.equalTo(view.snp.bottomMargin)
            make.leading.trailing.equalToSuperview()
        }

        blurView.contentView.addSubview(nutritionFactsView)
        nutritionFactsView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-view.frame.height)
        }

        view.addSubview(topMaskView)
        topMaskView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(16)
        }
    }

    @objc private func showSafariView(_ sender: UIButton) {
        guard
            let viewModel,
            let url = URL(string: viewModel.recipeURL)
        else { return }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let safariVC = SFSafariViewController(url: url, configuration: config)
        present(safariVC, animated: true)
    }

    @objc private func showNutritionFacts() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.blurView.alpha = 1
            self.nutritionFactsView.snp.updateConstraints { make in
                make.centerY.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }

    @objc private func hideNutritionFacts(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        switch sender.state {
        case .changed:
            if translation.y < 0 {
                nutritionFactsView.snp.updateConstraints { make in
                    make.centerY.equalToSuperview().offset(translation.y)
                }
                let alphaStep = 1 / view.frame.height
                blurView.alpha = 1 - alphaStep * abs(translation.y)
            }
        case .ended:
            UIView.animate(withDuration: 0.5) {
                if translation.y > -100 {
                    self.nutritionFactsView.snp.updateConstraints { make in
                        make.centerY.equalToSuperview()
                        self.blurView.alpha = 1
                    }
                } else {
                    self.nutritionFactsView.snp.updateConstraints { make in
                        make.centerY.equalToSuperview().offset(-self.view.frame.height)
                        self.blurView.alpha = 0
                    }
                }
                self.view.layoutIfNeeded()
            }
        default: break
        }
    }

    @objc private func favoriteButtonTapped() {
        interactor?.changeFavoriteState()
    }

    private func makeSeparator(color: UIColor = .black, thickness: CGFloat = 1) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.snp.makeConstraints { make in
            make.height.equalTo(thickness)
        }
        return view
    }

    // MARK: - request data from RecipeDetailsInteractor

    func start() {
        interactor?.showRecipeDetails()
    }

    // MARK: - display view model from RecipeDetailsPresenter

    func displayRecipeDetails(viewModel: RecipeDetails.ShowRecipeDetails.ViewModel) {
        self.viewModel = viewModel

        guard let url = URL(string: viewModel.imageURL) else { return }
        recipeImageView.setImageFrom(url: url)
        recipeTitleLabel.text = viewModel.title
        favoriteButton.imageView?.tintColor = viewModel.isFavorite ? .red : .white
        viewModel.ingredientRows.forEach { ingredient in
            let ingredientView = IngredientRowView(viewModel: ingredient)
            ingredientView.delegate = self
            ingridientsStack.addArrangedSubview(ingredientView)
            ingredientView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(60)
                make.centerX.equalToSuperview()
            }
        }
        nutritionFactsView.setup(with: viewModel.nutritionFactsViewModel)
    }

    func displayFavoriteState(viewModel: RecipeDetails.SetFavoriteState.ViewModel) {
        #warning("make animations")
        favoriteButton.imageView?.tintColor = viewModel.isFavorite ? .red : .white
    }
}

// MARK: - Extensions

extension RecipeDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        #warning("track navigation bar height obviosly its 91")
        if scrollView.contentOffset.y + 91 < 0 {
            topMaskView.snp.updateConstraints { make in
                make.height.equalTo(100)
                view.layoutIfNeeded()
            }
        }
    }
}

extension RecipeDetailsViewController: IngredientRowDelegate {
    func handleIngredientExistance(name: String, state: Bool) {
        let request = RecipeDetails.HandleIngredient.Request(name: name, state: state)
        interactor?.handleIngredient(request: request)
    }
}
