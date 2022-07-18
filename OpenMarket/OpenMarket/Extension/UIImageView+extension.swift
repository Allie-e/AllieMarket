//
//  UIImageView+extension.swift
//  OpenMarket
//
//  Created by Allie on 2022/07/18.
//

import UIKit

extension UIImageView {
    func load(url: String) {
        DispatchQueue.global().async { [weak self] in
            if let urlString = URL(string: url),
               let data = try? Data(contentsOf: urlString) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
