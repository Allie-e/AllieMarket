//
//  ProductDetailView.swift
//  OpenMarket
//
//  Created by Allie on 2022/07/09.
//

import UIKit

class ProductDetailView: UIScrollView {
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return stackView
    }()
    
    let productImageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 150, height: 150)
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor)
            .isActive = true
        
        return collectionView
    }()
    
    let nameAndStockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.textAlignment = .right
        
        return label
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fill
        
        return stackView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.textAlignment = .right
        
        return label
    }()
    
    let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.textAlignment = .right
        
        return label
    }()
    
    let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.font = .preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        setUpNameAndStockStackView()
        setUpPriceStackView()
        setUpEntireStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpEntireStackView() {
        [productImageCollectionView, nameAndStockStackView, priceStackView, productDescriptionTextView].forEach { view in
            entireStackView.addArrangedSubview(view)
        }
        
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
    
    func setUpNameAndStockStackView() {
        [nameLabel, stockLabel].forEach { view in
            nameAndStockStackView.addArrangedSubview(view)
        }
        
        stockLabel.setContentHuggingPriority(.required, for: .horizontal)
        stockLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func setUpPriceStackView() {
        [priceLabel, discountedPriceLabel].forEach { view in
            priceStackView.addArrangedSubview(view)
        }
    }
    
    func setUpStockLabel(with stock: Int) {
        if stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        } else {
            stockLabel.text = "잔여수량 : \(stock)"
            stockLabel.textColor = .systemGray
        }
    }
    
    func setUpPriceLabel(price: Double, discountedPrice: Double, currency: Currency) {
        if discountedPrice == 0 {
            priceLabel.text = "\(currency.description) \(price.formattedNumber())"
            priceLabel.textColor = .systemGray
        } else {
            priceLabel.text = "\(currency.description) \(price.formattedNumber())"
            priceLabel.textColor = .red
            priceLabel.attributedText = priceLabel.text?.strikeThrough()
            discountedPriceLabel.text = "\(currency.description) \(discountedPrice.formattedNumber())"
            discountedPriceLabel.textColor = .systemGray
        }
    }
}
