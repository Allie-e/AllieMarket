//
//  ProductRegisterView.swift
//  OpenMarket
//
//  Created by Allie on 2022/06/23.
//

import UIKit

class ProductRegisterView: UIView {
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        
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
        addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            productImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            productImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            productImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            productImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
}
