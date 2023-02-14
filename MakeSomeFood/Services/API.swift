//
//  API.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//

import Foundation

struct API {
//https://api.edamam.com/api/recipes/v2?type=any&app_id=5e0682f3&app_key=5493c326a96a8cda446d0f943cb7c55d&imageSize=REGULAR&random=true
    static let scheme = "https"
    static let host = "api.edamam.com"

    static let getRandomRecipies = "/api/recipes/v2"
}
