//
//  CachedUIImage.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 18.02.2023.
//

import UIKit

final class CachedUIImageView: UIImageView {
    
    func setImageFrom(url: URL?) {
        guard let url else { return }
        if let cachedImage = ImageCache[url.lastPathComponent] {
            image = cachedImage
        } else {
            image = UIImage(named: "placeholder")
            DispatchQueue.global().async { [weak self] in
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async { [weak self] in
                        self?.image = image
                        ImageCache[url.lastPathComponent] = image

                }
            }
        }
    }
}
