//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by Allie on 2022/07/11.
//

import UIKit

class ProductDetailViewController: UIViewController {
    private let productDetailView = ProductDetailView()
    private var imageCollectionView: UICollectionView!
    private let api = APIManager()
    private var productDetail: ProductDetailInformation?
    private var productImages = [UIImage]()
    var productId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        getProductDetail()
        setUpUI()
        setUpCollectionViewCell()
    }
    
    private func setUpNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapActionButton))
    }
    
    @objc private func didTapActionButton() {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        let editButton = UIAlertAction(title: "수정", style: .default, handler: nil)
        let deleteButton = UIAlertAction(title: "삭제", style: .destructive, handler: nil)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [editButton, deleteButton, cancelButton].forEach { action in
            alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setUpUI() {
        view.addSubview(productDetailView)
        productDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            productDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setUpCollectionViewCell() {
        imageCollectionView = productDetailView.productImageCollectionView
        imageCollectionView.register(ProductDetailImageCell.self, forCellWithReuseIdentifier: ProductDetailImageCell.identifier)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
    }
    
    private func setUpDetail(with product: ProductDetailInformation) {
        setUpProductName(with: product)
        setUpProductStock(with: product)
        setUpProductPrice(with: product)
        setUpProductDescription(with: product)
    }
    
    private func setUpProductName(with product: ProductDetailInformation) {
        productDetailView.nameLabel.text = product.name
    }
    
    private func setUpProductStock(with product: ProductDetailInformation) {
        productDetailView.setUpStockLabel(with: product.stock)
    }
    
    private func setUpProductPrice(with product: ProductDetailInformation) {
        productDetailView.setUpPriceLabel(price: product.price, discountedPrice: product.discountedPrice, currency: product.currency)
    }
    
    private func setUpProductDescription(with product: ProductDetailInformation) {
        productDetailView.productDescriptionTextView.text = product.description
    }
    
    func getProductDetail() {
        guard let productId = productId else {
            return
        }

        api.requestProductInformation(productID: productId) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.productDetail = data
                    self.setUpDetail(with: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDetail?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailImageCell.identifier, for: indexPath) as? ProductDetailImageCell else {
            return ProductDetailImageCell()
        }
        
        guard let productDetail = productDetail else {
            return ProductDetailImageCell()
        }
        
        let url = productDetail.images[indexPath.item].url
        cell.setUpProductImage(with: url)
        
        return cell
    }
}
