//
//  ProductDetailImageCell.swift
//  OpenMarket
//
//  Created by Allie on 2022/07/09.
//

import UIKit

class ProductDetailImageCell: UICollectionViewCell {
    static let identifier = "ProductDetailImageCell"
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        contentView.addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    func setUpProductImage(with url: String) {
        productImageView.load(url: url)
    }
}
