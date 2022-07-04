//
//  ProductImageCell.swift
//  OpenMarket
//
//  Created by Allie on 2022/07/03.
//

import UIKit

class ProductImageCell: UICollectionViewCell {
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        let minus = AccessoryImage.minus
        button.setImage(minus, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 13
        button.tintColor = .systemRed
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        [productImageView, deleteButton].forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -10),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
        ])
    }
    
    func setUpProductImage(with image: UIImage) {
        productImageView.image = image
    }
}
