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

    // MARK: - Private properties
    private var imageURL: URL? {
        didSet {
            imageView.image = UIImage(named: "placeholder")
            loadImage()
        }
    }

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
        imageView.layer.cornerRadius = 16
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

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        setupUI()
    }

    // MARK: - Public methods

    func setup(with viewModel: RecipeCellViewModelRepresentable) {
        dishNameLabel.text = viewModel.dishName
        guard let url = URL(string: viewModel.imageURL) else { return }
        imageURL = url
    }


    // MARK: - Private methods

    private func loadImage() {
        if let cachedImage = ImageCache[imageURL?.lastPathComponent ?? ""] {
            imageView.image = cachedImage
        } else {
            guard let url = imageURL else { return }
            DispatchQueue.global().async { [weak self] in
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async { [weak self] in
                    if url == self?.imageURL {
                        self?.imageView.image = image
                        ImageCache[url.lastPathComponent] = image
                        self?.indicatorView.stopAnimating()
                    }
                }
            }
        }
    }

    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.layer.shadowOpacity = 0.5
    }

    private func setupConstraints() {
        contentView.addSubview(imageView)
        imageView.addSubview(labelView)
        imageView.addSubview(indicatorView)
        labelView.addSubview(dishNameLabel)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        labelView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(dishNameLabel.snp.height).offset(16)
        }

        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        dishNameLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
