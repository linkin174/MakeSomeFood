//
//  CachedUIImage.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 18.02.2023.
//

import UIKit

final class CachedUIImageView: UIImageView {

    private var imageURL: URL?

    func setImageFrom(url: URL) {
        imageURL = url
        if let cachedImage = ImageCache[url.lastPathComponent] {
            print("LOADED FROM CACHE")
            image = cachedImage
        } else {
            DispatchQueue.global().async { [unowned self] in
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async { [unowned self] in
                    if url == self.imageURL {
                        self.image = image
                        ImageCache[url.lastPathComponent] = image
                    }
                }
            }
        }
    }
}
