//
//  ImageCache.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//

import UIKit

final class ImageCache {

    private static var cache = NSCache<NSString, UIImage>()

    static subscript(urlString: String) -> UIImage? {
        get {
            ImageCache.cache.object(forKey: urlString as NSString)
        } set {
            if let newValue {
                ImageCache.cache.setObject(newValue, forKey: urlString as NSString)
            }
        }
    }
}
