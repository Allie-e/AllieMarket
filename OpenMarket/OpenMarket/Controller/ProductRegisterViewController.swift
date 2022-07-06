//
//  ProductRegisterViewController.swift
//  OpenMarket
//
//  Created by Allie on 2022/06/22.
//

import UIKit

class ProductRegisterViewController: UIViewController {
    private var productImages: [UIImage] = [] {
        didSet {
            imageCollectionView.reloadData()
        }
    }
    private let maxNumber = 5
    var imageCollectionView: UICollectionView!
    let productRegisterView = ProductRegisterView()
    let productImagePicker = ProductImagePickerController()
    let api = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        self.productImagePicker.delegate = self
        setUpUI()
        setUpCollectionViewCell()
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "상품등록"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
    }
    
    private func setUpUI() {
        view.addSubview(productRegisterView)
        productRegisterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productRegisterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            productRegisterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            productRegisterView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            productRegisterView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    func setUpCollectionViewCell() {
        imageCollectionView = productRegisterView.ProductImageCollectionView
        imageCollectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
        imageCollectionView.register(ProductImageCellFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ProductImageCellFooterView.identifier)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
    }
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapDoneButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func pickProductImage() {
        self.present(self.productImagePicker, animated: true)
    }

}

extension ProductRegisterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier, for: indexPath) as? ProductImageCell else {
            return ProductImageCell()
        }
        
        cell.setUpProductImage(with: productImages[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProductImageCellFooterView.identifier, for: indexPath) as? ProductImageCellFooterView else {
            return UICollectionReusableView()
        }
        
        footerView.addButton.addTarget(self, action: #selector(pickProductImage), for: .touchUpInside)
        
        return footerView
    }
}

extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentCamera() {
        productImagePicker.sourceType = .camera
        productImagePicker.allowsEditing = true
        productImagePicker.cameraFlashMode = .on
        
        present(productImagePicker, animated: true, completion: nil)
    }
    
    func presentAlbum() {
        productImagePicker.sourceType = .photoLibrary
        productImagePicker.allowsEditing = true
        
        present(productImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
