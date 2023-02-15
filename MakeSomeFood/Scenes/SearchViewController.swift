//
//  SearchViewController.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 15.02.2023.
//

import SwiftUI
import SnapKit
import DropDown

final class SearchViewController: UIViewController {

    // MARK: - Private Propertis

    let storageService: StorageService

    // MARK: - Views

    private let dietLabel = UILabel.makeUILabel(text: "Diet:",
                                                font: .systemFont(ofSize: 20, weight: .bold),
                                                textColor: .white)

    private let cuisineTypeLabel = UILabel.makeUILabel(text: "Cuisine:",
                                                       font: .systemFont(ofSize: 20, weight: .bold),
                                                       textColor: .white)

    private let mealTypeLabel = UILabel.makeUILabel(text: "Meal:",
                                                    font: .systemFont(ofSize: 20, weight: .bold),
                                                    textColor: .white)

    private let dishTypeLabel = UILabel.makeUILabel(text: "Dish:",
                                                    font: .systemFont(ofSize: 20, weight: .bold),
                                                    textColor: .white)

    private lazy var selectedDietLabel = UILabel.makeUILabel(text: "Any",
                                                             font: .systemFont(ofSize: 18, weight: .bold),
                                                             textColor: .white,
                                                             onTapGesture: #selector(showDietMenu), target: self)

    private lazy var selectedCuisineLabel = UILabel.makeUILabel(text: "Any",
                                                                font: .systemFont(ofSize: 18, weight: .bold),
                                                                textColor: .white,
                                                                onTapGesture: #selector(showCuisineMenu),
                                                                target: self)

    private lazy var selectedMealLabel = UILabel.makeUILabel(text: "Any",
                                                            font: .systemFont(ofSize: 18, weight: .bold),
                                                            textColor: .white,
                                                            onTapGesture: #selector(showMealMenu),
                                                            target: self)

    private lazy var selectedDishLabel = UILabel.makeUILabel(text: "Any",
                                                             font: .systemFont(ofSize: 18, weight: .bold),
                                                             textColor: .white,
                                                             onTapGesture: #selector(showDishMenu),
                                                             target: self)

    private lazy var dietMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = storageService.dietList
        menu.anchorView = selectedDietLabel
        menu.topOffset = CGPoint(x: 0, y: 32)
        menu.selectionAction = { [weak self] index, title in
            self?.selectedDietLabel.text = title
        }
        return menu
    }()

    private lazy var cuisineMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = storageService.cuisineTypes
        menu.anchorView = selectedCuisineLabel
        menu.topOffset = CGPoint(x: 0, y: 32)
        menu.selectionAction = { [weak self] index, title in
            self?.selectedCuisineLabel.text = title
        }
        return menu
    }()

    private lazy var mealMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = storageService.mealTypes
        menu.anchorView = selectedMealLabel
        menu.topOffset = CGPoint(x: 0, y: 32)
        menu.selectionAction = { [weak self] index, title in
            self?.selectedMealLabel.text = title
        }
        return menu
    }()

    private lazy var dishMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = storageService.dishTypes
        menu.anchorView = selectedMealLabel
        menu.topOffset = CGPoint(x: 0, y: 32)
        menu.selectionAction = { [weak self] index, title in
            self?.selectedDishLabel.text = title
        }
        return menu
    }()


    // MARK: - Initializers
    init(storageService: StorageService) {
        self.storageService = storageService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupConstraints()
    }

    // MARK: - Private Methods

    private func setupConstraints() {
        view.addSubview(dietMenu)
        view.addSubview(cuisineMenu)
        view.addSubview(dietLabel)
        view.addSubview(selectedDietLabel)
        view.addSubview(cuisineTypeLabel)
        view.addSubview(selectedCuisineLabel)
        view.addSubview(mealTypeLabel)
        view.addSubview(selectedMealLabel)
        view.addSubview(dishTypeLabel)
        view.addSubview(selectedDishLabel)

        #warning("make cycle!")

        dietLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.top.equalToSuperview().offset(100)
        }

        cuisineTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.top.equalTo(dietLabel.snp.bottom).offset(32)
        }

        mealTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.top.equalTo(cuisineTypeLabel.snp.bottom).offset(32)
        }

        dishTypeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.top.equalTo(mealTypeLabel.snp.bottom).offset(32)
        }

        selectedDietLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(32)
            make.centerY.equalTo(dietLabel.snp.centerY)
        }

        selectedCuisineLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(32)
            make.centerY.equalTo(cuisineTypeLabel.snp.centerY)
        }

        selectedMealLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(32)
            make.centerY.equalTo(mealTypeLabel.snp.centerY)
        }

        selectedDishLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(32)
            make.top.equalTo(selectedMealLabel.snp.bottom).offset(32)
        }

    }

    @objc private func showDietMenu() {
        dietMenu.show()
    }

    @objc private func showCuisineMenu() {
        cuisineMenu.show()
    }

    @objc private func showMealMenu() {
        mealMenu.show()
    }

    @objc private func showDishMenu() {
        dishMenu.show()
    }
}

// MARK: - Preview

struct SearchViewController_Prviews: PreviewProvider {
    static var previews: some View {
        SearchViewController(storageService: StorageService())
            .makePreview()
    }
}
