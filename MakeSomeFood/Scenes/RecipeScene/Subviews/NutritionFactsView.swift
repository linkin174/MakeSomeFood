//
//  NutritionFactsView.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 20.02.2023.
//

import SnapKit
import UIKit

protocol NutritionFactsViewRepresentable {
    var servings: String { get }
    var caloriesPerServing: String { get }
    var nutrients: [NutrientRowViewRepresentable] { get }
    var vitamins: [NutrientRowViewRepresentable] { get }
}

final class NutritionFactsView: UIView {

    // MARK: - Views
    private let headerLabel = UILabel.makeUILabel(text: "Nutrition Facts",
                                                  font: .systemFont(ofSize: 34, weight: .black))
    private let servingsLabel = UILabel.makeUILabel(text: "Servings",
                                                    font: .systemFont(ofSize: 18),
                                                    alignment: .left)
    private let ammountPerServingsLabel = UILabel.makeUILabel(text: "Ammount per serving",
                                                              font: .systemFont(ofSize: 14, weight: .black),
                                                              alignment: .left)
    private let caloriesTextLabel = UILabel.makeUILabel(text: "Calories",
                                                        font: .systemFont(ofSize: 32, weight: .black),
                                                        alignment: .left)
    private let caloriesValueLabel = UILabel.makeUILabel(text: "230",
                                                         font: .systemFont(ofSize: 32, weight: .black),
                                                         alignment: .right)
    private let dailyValueText = UILabel.makeUILabel(text: "% Daily value*",
                                                     font: .systemFont(ofSize: 16, weight: .bold),
                                                     alignment: .right)

    private let separator1 = makeSeparator()
    private let separator2 = makeSeparator()
    private let separator3 = makeSeparator()
    private let separator4 = makeSeparator()

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

    // MARK: - Public methods

    func setup(with viewModel: NutritionFactsViewRepresentable) {
        servingsLabel.text = "Servings: \(viewModel.servings)"
        caloriesValueLabel.text = viewModel.caloriesPerServing
        viewModel.nutrients.forEach { nutrient in
            let view = NutrientRowView()
            view.setup(with: nutrient)
            nutrientsStackView.addArrangedSubview(view)
            view.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(30)
            }
        }
        viewModel.vitamins.forEach { vitamin in
            let view = NutrientRowView()
            view.setup(with: vitamin)
            vitaminsStackView.addArrangedSubview(view)
            view.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(30)
            }
        }
    }

    // MARK: - Private methods

    private func setupConstraints() {
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
        }

        addSubview(separator1)

        separator1.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(2)
            make.top.equalTo(headerLabel.snp.bottom).offset(8)
        }

        addSubview(servingsLabel)
        servingsLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.top.equalTo(separator1.snp.bottom).offset(8)
        }

        addSubview(separator2)

        separator2.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
            make.top.equalTo(servingsLabel.snp.bottom).offset(8)
        }

        addSubview(ammountPerServingsLabel)
        ammountPerServingsLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.top.equalTo(separator2.snp.bottom).offset(4)
        }

        addSubview(caloriesTextLabel)
        caloriesTextLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.top.equalTo(ammountPerServingsLabel.snp.bottom).offset(4)
        }

        addSubview(caloriesValueLabel)
        caloriesValueLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(caloriesTextLabel.snp.top)
        }

        addSubview(separator3)
        separator3.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(6)
            make.top.equalTo(caloriesTextLabel.snp.bottom).offset(8)
        }

        addSubview(dailyValueText)
        dailyValueText.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.top.equalTo(separator3.snp.bottom).offset(4)
        }

        addSubview(nutrientsStackView)
        nutrientsStackView.snp.makeConstraints { make in
            make.top.equalTo(dailyValueText.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        addSubview(separator4)
        separator4.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.top.equalTo(nutrientsStackView.snp.bottom)
        }

        addSubview(vitaminsStackView)
        vitaminsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(separator4.snp.bottom)
        }
    }
}
