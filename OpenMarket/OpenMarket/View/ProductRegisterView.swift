//
//  ProductRegisterView.swift
//  OpenMarket
//
//  Created by Allie on 2022/06/24.
//

import UIKit

class ProductRegisterView: UIScrollView {
    private let entireStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let ProductImageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView.collectionViewLayout = layout
        
        return collectionView
    }()
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let priceTextFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        
        return stackView
    }()
    
    let productNameTextField = ProductInformationTextField(placeholder: "상품명")
    let priceTextField = ProductInformationTextField(placeholder: "상품가격")
    let discountPriceTextField = ProductInformationTextField(placeholder: "할인금액")
    let stockTextField = ProductInformationTextField(placeholder: "재고수량")
    let currencySegmentedControl = MarketSegmentedControl(items: ["KRW", "USD"])
    
    let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        textView.isScrollEnabled = false
        textView.font = .preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        setUpEntireStackView()
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpEntireStackView() {
        self.addSubview(entireStackView)
        entireStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            entireStackView.topAnchor.constraint(equalTo: self.topAnchor),
            entireStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            entireStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            entireStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            entireStackView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func addSubviews() {
        [ProductImageCollectionView, textFieldStackView, productDescriptionTextView].forEach { view in
            entireStackView.addArrangedSubview(view)
        }
        
        [priceTextField, currencySegmentedControl].forEach { view in
            priceTextFieldStackView.addArrangedSubview(view)
        }
        
        [productNameTextField, priceTextFieldStackView, discountPriceTextField, stockTextField].forEach { view in
            textFieldStackView.addArrangedSubview(view)
        }
    }
}
