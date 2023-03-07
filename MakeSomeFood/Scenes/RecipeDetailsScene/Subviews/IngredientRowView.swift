//
//  IngredientCellView.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 25.02.2023.
//

import UIKit
import SnapKit

protocol IngredientViewModelProtocol {
    var imageURL: String { get }
    var name: String { get }
    var food: String { get }
    var weight: String { get }
    var isExisting: Bool { get set }
}

protocol IngredientRowDelegate {
    func handleIngredientExistance(name: String, state: Bool)
}

final class IngredientRowView: UIView {
    // MARK: - Public properties

    var delegate: IngredientRowDelegate!
    
    // MARK: - Private properties

    private var viewModel: IngredientViewModelProtocol

    // MARK: - Views

    private let ingredientImageView: CachedUIImageView = {
        let imageView = CachedUIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel = UILabel.makeUILabel(font: .systemFont(ofSize: 14, weight: .semibold), alignment: .left)

    private let weightValueLabel = UILabel.makeUILabel(font: .systemFont(ofSize: 14))

    private lazy var checkImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray
        view.onTapGesture(target: self, action: #selector(checkButtonTapped))
        return view
    }()

    // MARK: - Initializers

    init(viewModel: IngredientViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
        setupConstraints()
        dropShadow()

        nameLabel.numberOfLines = 2
        backgroundColor = .mainAccentColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    @objc private func checkButtonTapped() {
        FeedbackService.shared.makeFeedback(event: .impactOccured)

        UIView.animate(withDuration: 0.15, delay: 0) { [weak self] in
            self?.checkImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }

        UIView.animate(withDuration: 0.15, delay: 0.15) { [weak self] in
            self?.checkImageView.transform = .identity
        }

        UIView.transition(with: self.checkImageView, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            if !(self?.viewModel.isExisting ?? false) {
                self?.checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
                self?.checkImageView.tintColor = .mainTintColor
            } else {
                self?.checkImageView.image = UIImage(systemName: "checkmark.circle")
                self?.checkImageView.tintColor = .disabledColor
            }
        }
        viewModel.isExisting.toggle()
        delegate.handleIngredientExistance(name: viewModel.food, state: viewModel.isExisting)
    }

    private func setup() {
        let url = URL(string: viewModel.imageURL)
        ingredientImageView.setImageFrom(url: url)
        nameLabel.text = viewModel.name
        weightValueLabel.text = viewModel.weight + " g."
        if viewModel.isExisting {
            checkImageView.tintColor = .mainTintColor
            checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        }
    }

    private func setupConstraints() {
        ingredientImageView.layer.cornerRadius = 22

        layer.cornerRadius = 30
        addSubview(ingredientImageView)
        ingredientImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(snp.height).inset(8)
            make.centerY.equalToSuperview()
        }

        addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            let inset = (60 - 32) / 2
            make.trailing.equalToSuperview().inset(inset)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }

        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalTo(ingredientImageView.snp.trailing).offset(8)
            make.trailing.equalTo(checkImageView.snp.leading)
        }

        addSubview(weightValueLabel)
        weightValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom)
        }
    }
}
