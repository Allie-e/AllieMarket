//
//  ProductRegisterViewController.swift
//  OpenMarket
//
//  Created by Allie on 2022/06/22.
//

import UIKit

class ProductRegisterViewController: UIViewController {
    let productImagePicker = ProductImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        self.productImagePicker.delegate = self
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "상품등록"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
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
