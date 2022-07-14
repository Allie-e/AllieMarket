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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpCollectionViewCell()
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
}

extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDetail?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailImageCell.identifier, for: indexPath) as? ProductDetailImageCell else {
            return ProductDetailImageCell()
        }
        
        return cell
    }
}
