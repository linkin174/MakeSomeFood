//
//  NutrientRowView.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 25.02.2023.
//
import UIKit

protocol NutrientRowViewRepresentable {
    var name: String { get }
    var value: String { get }
    var unit: String { get }
    var dailyPercentage: String { get }
}

final class NutrientRowView: UIView {
    // MARK: - Views

    private let nutrientNameLabel = UILabel.makeUILabel(font: .systemFont(ofSize: 20, weight: .black))
    private let nutrientValueLabel = UILabel.makeUILabel(font: .systemFont(ofSize: 20))
    private let nutrientPercentageLabel = UILabel.makeUILabel(font: .systemFont(ofSize: 20, weight: .black))
    private let separator = makeSeparator()

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    // MARK: - Public properties

    func setup(with viewModel: NutrientRowViewRepresentable) {
        nutrientNameLabel.text = viewModel.name
        nutrientValueLabel.text = viewModel.value + viewModel.unit
        nutrientPercentageLabel.text = viewModel.dailyPercentage + "%"
    }

    // MARK: - Private methods

    private func setupConstraints() {
        addSubview(separator)
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
            make.top.equalToSuperview()
        }

        addSubview(nutrientNameLabel)
        nutrientNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }

        addSubview(nutrientValueLabel)
        nutrientValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(nutrientNameLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }

        addSubview(nutrientPercentageLabel)
        nutrientPercentageLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
