//
//  ProductImageCell.swift
//  OpenMarket
//
//  Created by Allie on 2022/07/03.
//

import UIKit

class ProductImageCell: UICollectionViewCell {
    static let identifier = "ProductImageCell"
    private let productImageView = UIImageView()
    var indexPath: IndexPath?
    
    let deleteButton: UIButton = {
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
        setUpUI()
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
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    func setUpProductImage(with image: UIImage) {
        productImageView.image = image
    }
    
    func searchIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UICollectionView else {
            print("superview is not a UICollectionView - getIndexPath")
            return nil
        }
        let indexPath = superView.indexPath(for: self)
        self.indexPath = indexPath
        
        return indexPath
    }
}
