//
//  ProductDetailImageCell.swift
//  OpenMarket
//
//  Created by Allie on 2022/07/09.
//

import UIKit

class ProductDetailImageCell: UICollectionViewCell {
    static let identifier = "ProductDetailImageCell"
    private let productImageView = UIImageView()
    
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
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor)
        ])
    }
    
    func setUpProductImage(with url: String) {
        productImageView.load(url: url)
    }
}
