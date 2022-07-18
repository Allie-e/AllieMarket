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
        stackView.spacing = 8
        
        return stackView
    }()
    
    let productImageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 200, height: 200)
        collectionView.collectionViewLayout = layout
        collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor).isActive = true
        
        return collectionView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
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
    
    private let stockAndPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.textAlignment = .right
        
        return label
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
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = .preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setUpEntireStackView()
        setUpLabelStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        self.addSubview(entireStackView)
        [productImageCollectionView, labelStackView, productDescriptionTextView].forEach { view in
            entireStackView.addArrangedSubview(view)
        }
        
        [labelStackView, stockAndPriceStackView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [nameLabel, stockAndPriceStackView].forEach { view in
            labelStackView.addArrangedSubview(view)
        }
        
        [stockLabel, priceLabel, discountedPriceLabel].forEach { view in
            stockAndPriceStackView.addArrangedSubview(view)
        }
    }
    
    func setUpEntireStackView() {
        entireStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            entireStackView.topAnchor.constraint(equalTo: self.topAnchor),
            entireStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            entireStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            entireStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            entireStackView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    func setUpLabelStackView() {
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: productDescriptionTextView.topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
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
