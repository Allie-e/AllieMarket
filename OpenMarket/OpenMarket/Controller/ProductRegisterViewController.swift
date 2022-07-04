//
//  ProductRegisterViewController.swift
//  OpenMarket
//
//  Created by Allie on 2022/06/22.
//

import UIKit

class ProductRegisterViewController: UIViewController {
    enum Section: CaseIterable {
        case image
    }
    
    let productRegisterView = ProductRegisterView()
    let productImagePicker = ProductImagePickerController()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>?
    var imageCollectionView: UICollectionView!
    
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
        imageCollectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: "ProductImageCell")
        
        dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: imageCollectionView, cellProvider: { (collectionView, indexPath, product) -> ProductImageCell in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as? ProductImageCell else {
                return ProductImageCell()
            }
            
            return cell
        })
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
