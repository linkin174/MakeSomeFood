//
//  FavoritesViewController.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 28.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FavoritesDisplayLogic: AnyObject {
    func displaySomething(viewModel: Favorites.Something.ViewModel)
}

final class FavoritesViewController: UIViewController, FavoritesDisplayLogic {

    // MARK: - Public Properties

    var interactor: FavoritesBusinessLogic?
    var router: (NSObjectProtocol & FavoritesRoutingLogic & FavoritesDataPassing)?

    // MARK: - Views

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .blue
        return tableView
    }()

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        FavoritesConfigurator.shared.configure(with: self)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        FavoritesConfigurator.shared.configure(with: self)
        setupConstraints()
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onLoad()
    }

    // MARK: - Private Methods

    private func setupConstraints() {
        view.addSubview(tableView)
    }

    func onLoad() {
        interactor?.start()
    }

    func displaySomething(viewModel: Favorites.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}
