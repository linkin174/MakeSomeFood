//
//  RecipeCell.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//

import UIKit
import SnapKit

protocol RecipeCellViewModelRepresentable {
    var dishName: String { get }
    var imageURL: String { get }
}

final class RecipeCell: UICollectionViewCell {

    // MARK: - Public properties

    static let reuseID = "recipeCell"

    // MARK: - Views

    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        return indicator
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(named: "placeholder")
        return imageView
    }()

    private let dishNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 3
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let labelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.opacity = 0.9
        view.addSubview(blurEffectView)
        return view
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func setup(with viewModel: RecipeCellViewModelRepresentable) {
        #warning("resolve optionals")
        dishNameLabel.text = viewModel.dishName
        Task {
            let data = try? await URLSession.shared.data(for: URLRequest(url: URL(string: viewModel.imageURL)!))
            let image = UIImage(data: data!.0)!
            DispatchQueue.main.async {
                self.imageView.image = image
                self.indicatorView.stopAnimating()
            }
        }
    }

    // MARK: - Private methods

    private func setupUI() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.layer.shadowOpacity = 0.5
    }

    private func setupConstraints() {
        // Setup 1st layer
        contentView.addSubview(imageView)
        imageView.addSubview(labelView)
        imageView.addSubview(indicatorView)
        labelView.addSubview(dishNameLabel)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Setup second layer


        labelView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(dishNameLabel.snp.height).offset(16)
        }

        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // Setup third layer


        dishNameLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
