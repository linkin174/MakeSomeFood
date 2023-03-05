//
//  RecipeCell.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//

import UIKit
import SnapKit

protocol RecipeCellViewModelProtocol {
    var dishName: String { get }
    var imageURL: URL? { get }
}

protocol RecipeCellRepresentable {
    var viewModel: RecipeCellViewModelProtocol? { get set }
}

final class RecipeCell: UICollectionViewCell, RecipeCellRepresentable {

    // MARK: - Public properties

    static let reuseID = "recipeCell"

    // MARK: - Private properties

    var viewModel: RecipeCellViewModelProtocol? {
        didSet {
            updateView()
        }
    }

    // MARK: - Views

    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        indicator.color = .black.withAlphaComponent(0.6)
        return indicator
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.image = UIImage(named: "placeholder")
        return imageView
    }()

    private let dishNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let labelBackgroundView: UIView = {
        let view = UIView()
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.opacity = 0.9
        view.addSubview(blurEffectView)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        contentView.dropShadow(color: .black, offset: CGSize(width: 0, height: 2), radius: 5, opacity: 0.65)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func updateView() {
        dishNameLabel.text = viewModel?.dishName
        cacheAndRender()
    }

    private func cacheAndRender() {
        guard let url = viewModel?.imageURL else { return }
        if let cachedImage = ImageCache[url.lastPathComponent] {
            imageView.image = cachedImage
            indicatorView.stopAnimating()
        } else {
            imageView.image = UIImage(named: "placeholder")
            indicatorView.startAnimating()
            DispatchQueue.global().async { [weak self] in
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async { [weak self] in
                    if url == self?.viewModel?.imageURL {
                        self?.indicatorView.stopAnimating()
                        self?.imageView.image = image
                        ImageCache[url.lastPathComponent] = image
                    }
                }
            }
        }
    }

    private func setupConstraints() {
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.addSubview(labelBackgroundView)
        labelBackgroundView.addSubview(dishNameLabel)
        
        labelBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(dishNameLabel.snp.height).offset(8)
        }

        imageView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        dishNameLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(4)
            make.height.equalTo(40)
        }
    }
}
