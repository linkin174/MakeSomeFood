//
//  RecipeDetailsRouter.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol RecipeDetailsRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol RecipeDetailsDataPassing {
    var dataStore: RecipeDetailsDataStore? { get }
}

class RecipeDetailsRouter: NSObject, RecipeDetailsRoutingLogic, RecipeDetailsDataPassing {
    weak var viewController: RecipeDetailsViewController?
    var dataStore: RecipeDetailsDataStore?
}
