//
//  ProductRegisterView.swift
//  OpenMarket
//
//  Created by Allie on 2022/06/24.
//

import UIKit

class ProductRegisterView: UIScrollView {
    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    private let productImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        return stackView
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    let addImageButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        button.setImage(AccessoryImage.plus, for: .normal)
        
        return button
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
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        setUpProductImageView()
        setUpRegisterView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpProductImageView() {
        productImageStackView.addArrangedSubview(productImageView)
        productImageStackView.addArrangedSubview(addImageButton)
        imageScrollView.addSubview(productImageStackView)
        self.addSubview(imageScrollView)
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        productImageStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageScrollView.heightAnchor.constraint(equalToConstant: 100),
            imageScrollView.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            productImageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            productImageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            productImageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            productImageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            productImageStackView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor)
        ])
    }
    
    private func setUpRegisterView() {
        self.addSubview(textFieldStackView)
        self.addSubview(productDescriptionTextView)
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        productDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        priceTextFieldStackView.addArrangedSubview(priceTextField)
        priceTextFieldStackView.addArrangedSubview(currencySegmentedControl)
        
        textFieldStackView.addArrangedSubview(productNameTextField)
        textFieldStackView.addArrangedSubview(priceTextFieldStackView)
        textFieldStackView.addArrangedSubview(discountPriceTextField)
        textFieldStackView.addArrangedSubview(stockTextField)
        
        NSLayoutConstraint.activate([
            textFieldStackView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            textFieldStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textFieldStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textFieldStackView.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            productDescriptionTextView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor),
            productDescriptionTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            productDescriptionTextView.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
            productDescriptionTextView.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
        ])
    }
}
