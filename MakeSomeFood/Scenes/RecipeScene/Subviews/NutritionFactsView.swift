//
//  NutritionFactsView.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 20.02.2023.
//

import SnapKit
import UIKit

protocol NutrientRowViewRepresentable {
    var name: String { get }
    var value: String { get }
    var unit: String { get }
    var dailyPercentage: String { get }
}

final class NutrientRowView: UIView {
    #warning("remove to extenstions")
    private var previousSubview: UIView? {
        if subviews.count > 2 {
            let lastIndex = subviews.endIndex - 2
            return subviews[lastIndex]
        } else {
            return nil
        }
    }

    private func makeSeparator(thickness: CGFloat = 1, color: UIColor = .black) {
        let view = UIView()
        view.backgroundColor = color
        addSubview(view)
        view.snp.makeConstraints { make in
            make.height.equalTo(thickness)
            make.width.equalToSuperview()
            if let previousSubview {
                make.top.equalTo(previousSubview.snp.bottom).offset(8)
            } else {
                make.top.equalToSuperview()
            }
        }
    }

    private let viewModel: NutrientRowViewRepresentable
    private let nutrientNameLabel = UILabel.makeUILabel(text: "Fat", font: .systemFont(ofSize: 20, weight: .black))
    private let nutrientValueLabel = UILabel.makeUILabel(text: "8g", font: .systemFont(ofSize: 20))
    private let nutrientPercentageLabel = UILabel.makeUILabel(text: "10%", font: .systemFont(ofSize: 20, weight: .black))

    init(viewModel: NutrientRowViewRepresentable) {
        self.viewModel = viewModel
        nutrientNameLabel.text = viewModel.name
        nutrientValueLabel.text = viewModel.value + viewModel.unit
        nutrientPercentageLabel.text = viewModel.dailyPercentage + "%"
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    // MARK: - Private methods

    private func setupConstraints() {
        makeSeparator(thickness: 1)

        addSubview(nutrientNameLabel)
        addSubview(nutrientValueLabel)
        addSubview(nutrientPercentageLabel)

        nutrientNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }

        nutrientValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(nutrientNameLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }

        nutrientPercentageLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

protocol NutritionFactsViewRepresentable {
    var servings: String { get }
    var caloriesPerServing: String { get }
    var nutrients: [NutrientRowViewRepresentable] { get }
    var vitamins: [NutrientRowViewRepresentable] { get }
}

final class NutritionFactsView: UIView {
    // MARK: - Private properties

    private var previousSubview: UIView {
        let lastIndex = subviews.endIndex - 2
        return subviews[lastIndex]
    }


    // MARK: - Views

    private let headerLabel = UILabel.makeUILabel(text: "Nutrition Facts", font: .systemFont(ofSize: 34, weight: .black))
    private let servingsLabel = UILabel.makeUILabel(text: "Servings", font: .systemFont(ofSize: 18), alignment: .left)
    private let ammountPerServingsLabel = UILabel.makeUILabel(text: "Ammount per serving", font: .systemFont(ofSize: 14, weight: .black), alignment: .left)
    private let caloriesTextLabel = UILabel.makeUILabel(text: "Calories", font: .systemFont(ofSize: 32, weight: .black), alignment: .left)
    private let caloriesValueLabel = UILabel.makeUILabel(text: "230", font: .systemFont(ofSize: 32, weight: .black), alignment: .right)
    private let dailyValueText = UILabel.makeUILabel(text: "% Daily value*", font: .systemFont(ofSize: 16, weight: .bold), alignment: .right)

    private let nutrientsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 0
        stack.backgroundColor = .white
        return stack
    }()

    private let vitaminsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 0
        stack.backgroundColor = .white
        return stack
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 16
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        dropShadow()
    }

    func setup(with viewModel: NutritionFactsViewRepresentable) {

        servingsLabel.text = "Servings: \(viewModel.servings)"

        caloriesValueLabel.text = viewModel.caloriesPerServing

        viewModel.nutrients.forEach { nutrient in
            let view = NutrientRowView(viewModel: nutrient)
            nutrientsStackView.addArrangedSubview(view)
            view.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(30)
            }
        }
        viewModel.vitamins.forEach { vitamin in
            let view = NutrientRowView(viewModel: vitamin)
            vitaminsStackView.addArrangedSubview(view)
            view.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(30)
            }
        }
    }

    private func setupConstraints() {
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
        }
        makeSeparator()

        addSubview(servingsLabel)
        servingsLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalTo(previousSubview.snp.bottom).offset(8)
        }

        makeSeparator(thickness: 10)

        addSubview(ammountPerServingsLabel)
        ammountPerServingsLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalTo(previousSubview.snp.bottom).offset(8)
        }

        addSubview(caloriesTextLabel)
        caloriesTextLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalTo(previousSubview.snp.bottom).offset(8)
        }

        addSubview(caloriesValueLabel)
        caloriesValueLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(caloriesTextLabel.snp.top)
        }

        makeSeparator(thickness: 6)

        addSubview(dailyValueText)
        dailyValueText.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalTo(previousSubview.snp.bottom).offset(8)
        }

        addSubview(nutrientsStackView)
        nutrientsStackView.snp.makeConstraints { make in
            make.top.equalTo(previousSubview.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        makeSeparator(thickness: 10, topOffset: 0)

        addSubview(vitaminsStackView)
        vitaminsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(previousSubview.snp.bottom)
        }
    }

    private func makeSeparator(thickness: CGFloat = 1, color: UIColor = .black, topOffset: CGFloat = 8, horizontalInset: CGFloat = 8) {
        let view = UIView()
        view.backgroundColor = color
        addSubview(view)
        view.snp.makeConstraints { make in
            make.height.equalTo(thickness)
            make.leading.trailing.equalToSuperview().inset(horizontalInset)
            make.top.equalTo(previousSubview.snp.bottom).offset(topOffset)
        }
    }
}
