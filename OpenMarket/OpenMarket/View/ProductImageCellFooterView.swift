//
//  ProductImageCellFooterView.swift
//  OpenMarket
//
//  Created by Allie on 2022/07/04.
//

import UIKit

class ProductImageCellFooterView: UICollectionReusableView {
    static let identifier = "ProductImageCellFooterView"
    let addButton: UIButton = {
       let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        button.setImage(AccessoryImage.plus, for: .normal)
        button.backgroundColor = .systemGray3
        
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
        self.backgroundColor = .systemGray3
        self.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor)
        ])
    }
    
    func hideAddButton() {
        addButton.removeFromSuperview()
    }
}
