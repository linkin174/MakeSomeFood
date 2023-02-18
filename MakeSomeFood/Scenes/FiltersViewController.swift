//
//  FiltersViewController.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 15.02.2023.
//

import DropDown
import SnapKit
import SwiftUI

protocol FiltersViewControllerDelegate {
    func reloadRecipies()
}

final class FiltersViewController: UIViewController {
    // MARK: - Public properties

    var delegate: FiltersViewControllerDelegate!

    // MARK: - Private Properties

    private var storageService: StorageService

    private var filtersHasChanges = false

    private var filters: Filters! {
        didSet {
            setupSelections()
        }
    }

    // MARK: - Views

    private lazy var queryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ingridient or meal... Not Required"
        textField.font = .systemFont(ofSize: 18)
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.dropShadow(offset: CGSize(width: 0, height: 5), opacity: 0.25)
        textField.clearButtonMode = .always
        textField.delegate = self
        return textField
    }()

    private let headerLabel = UILabel.makeUILabel(text: "Setup Filters", font: .systemFont(ofSize: 24, weight: .semibold))

    private let dietLabel = UILabel.makeUILabel(text: "Diet:",
                                                font: .systemFont(ofSize: 20, weight: .semibold))

    private let cuisineTypeLabel = UILabel.makeUILabel(text: "Cuisine:",
                                                       font: .systemFont(ofSize: 20, weight: .semibold))

    private let mealTypeLabel = UILabel.makeUILabel(text: "Meal:",
                                                    font: .systemFont(ofSize: 20, weight: .semibold))

    private let dishTypeLabel = UILabel.makeUILabel(text: "Dish:",
                                                    font: .systemFont(ofSize: 20, weight: .semibold))

    private let selectedDietLabel = UILabel.makeUILabel(text: "Any",
                                                        font: .systemFont(ofSize: 18, weight: .semibold))

    private let selectedCuisineLabel = UILabel.makeUILabel(text: "Any",
                                                           font: .systemFont(ofSize: 18, weight: .semibold))

    private let selectedMealLabel = UILabel.makeUILabel(text: "Any",
                                                        font: .systemFont(ofSize: 18, weight: .semibold))

    private let selectedDishLabel = UILabel.makeUILabel(text: "Any",
                                                        font: .systemFont(ofSize: 18, weight: .semibold))

    private let randomLabel = UILabel.makeUILabel(text: "Randomize results", font: .systemFont(ofSize: 20, weight: .semibold))

    private lazy var randomSwitch: UISwitch = {
        let randomSwitch = UISwitch()
        randomSwitch.onTintColor = #colorLiteral(red: 0.4139624238, green: 0.7990826964, blue: 0.003590217093, alpha: 1)
        randomSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return randomSwitch
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.4139624238, green: 0.7990826964, blue: 0.003590217093, alpha: 1)
        button.setTitle("Save filters", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.layer.cornerRadius = 12
        button.dropShadow(offset: CGSize(width: 0, height: 5), opacity: 0.25)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var dietMenu = DropDown.createMenu(dataSource: storageService.dietList,
                                                    anchorView: selectedDietLabel) { [unowned self] _, label in
        selectedDietLabel.text = label
        filtersHasChanges = true
    }

    private lazy var cuisineMenu = DropDown.createMenu(dataSource: storageService.cuisineTypes,
                                                       anchorView: selectedCuisineLabel) { [unowned self] _, label in
        selectedCuisineLabel.text = label
        filtersHasChanges = true
    }

    private lazy var mealMenu = DropDown.createMenu(dataSource: storageService.mealTypes, anchorView: selectedMealLabel) { [unowned self] _, label in
        selectedMealLabel.text = label
        filtersHasChanges = true
    }

    private lazy var dishMenu = DropDown.createMenu(dataSource: storageService.dishTypes, anchorView: selectedDishLabel) { [unowned self] _, label in
        selectedDishLabel.text = label
        filtersHasChanges = true
    }

    // MARK: - Initializers

    init(storageService: StorageService) {
        self.storageService = storageService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        setupConstraints()
        setupTapGestures()
        filters = storageService.loadFilters()
    }

    // MARK: - Private Methods

    private func setupConstraints() {

        view.addSubview(headerLabel)
        view.addSubview(queryTextField)
        view.addSubview(dishMenu)
        view.addSubview(dietLabel)
        view.addSubview(selectedDietLabel)
        view.addSubview(cuisineTypeLabel)
        view.addSubview(selectedCuisineLabel)
        view.addSubview(mealTypeLabel)
        view.addSubview(selectedMealLabel)
        view.addSubview(dishTypeLabel)
        view.addSubview(selectedDishLabel)
        view.addSubview(randomLabel)
        view.addSubview(randomSwitch)
        view.addSubview(saveButton)

        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
        }

        queryTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
            make.top.equalTo(headerLabel.snp.bottom).offset(16)
        }

        dietLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.top.equalTo(queryTextField.snp.bottom).offset(32)
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

        randomLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.top.equalTo(dishTypeLabel.snp.bottom).offset(32)
        }

        randomSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(32)
            make.top.equalTo(selectedDishLabel.snp.bottom).offset(32)
        }

        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(randomSwitch.snp.bottom).offset(100)
        }
    }

    private func setupSelections() {
        queryTextField.text = filters.searchQuery
        selectedDietLabel.text = filters.dietType
        selectedCuisineLabel.text = filters.cuisineType
        selectedMealLabel.text = filters.mealType
        selectedDishLabel.text = filters.dishType
        randomSwitch.isOn = filters.random
        // Select row of menus
        dietMenu.selectRow(at: storageService.dietList.firstIndex(of: filters.dietType))
        cuisineMenu.selectRow(at: storageService.cuisineTypes.firstIndex(of: filters.cuisineType))
        mealMenu.selectRow(at: storageService.mealTypes.firstIndex(of: filters.mealType))
        dishMenu.selectRow(at: storageService.dishTypes.firstIndex(of: filters.dishType))
    }

    private func setupTapGestures() {
        let viewsWithTapGesures = [selectedDietLabel, selectedCuisineLabel, selectedMealLabel, selectedDishLabel]
        for (index, view) in viewsWithTapGesures.enumerated() {
            view.onTapGesture(target: self, action: #selector(showMenus(sender:)), tag: index)
        }
        view.onTapGesture(target: self, action: #selector(didTapView))
    }

    @objc private func showMenus(sender: UITapGestureRecognizer) {
        switch sender.view?.tag {
        case 0:
            dietMenu.show()
        case 1:
            cuisineMenu.show()
        case 2:
            mealMenu.show()
        default:
            dishMenu.show()
        }
    }

    @objc private func saveButtonTapped() {
        queryTextField.endEditing(true)
        if filtersHasChanges {
            let filters = Filters(searchQuery: queryTextField.text,
                                  dietType: dietMenu.selectedItem ?? storageService.dietList[0],
                                  cuisineType: cuisineMenu.selectedItem ?? storageService.cuisineTypes[0],
                                  mealType: mealMenu.selectedItem ?? storageService.mealTypes[0],
                                  dishType: dishMenu.selectedItem ?? storageService.dishTypes[0],
                                  random: randomSwitch.isOn)
            storageService.save(filters: filters)
            delegate.reloadRecipies()
        }
        dismiss(animated: true)
    }

    @objc private func didTapView() {
        queryTextField.endEditing(true)
    }

    @objc private func switchValueChanged() {
        filtersHasChanges = true
    }
}

extension FiltersViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != filters.searchQuery {
            filtersHasChanges = true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

// MARK: - Preview

struct SearchViewController_Prviews: PreviewProvider {
    static var previews: some View {
        FiltersViewController(storageService: StorageService())
            .makePreview()
    }
}
