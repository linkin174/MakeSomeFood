//
//  ViewController.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//

import UIKit
import SnapKit

class JokeViewController: UIViewController {

    // MARK: - Private properties

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.5741398931, blue: 0.2584492564, alpha: 1)
        setupConstraints()
        loadJoke()
    }

    // MARK: - Private methods

    private func setupConstraints() {
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(32)
        }
    }

    private func loadJoke() {

    }
}

