//
//  ProductRegisterViewController.swift
//  OpenMarket
//
//  Created by Allie on 2022/06/22.
//

import UIKit

class ProductRegisterViewController: UIViewController {
    private let maxNumber = 5
    private var imageCollectionView: UICollectionView!
    private let productRegisterView = ProductRegisterView()
    private let productImagePicker = UIImagePickerController()
    private let api = APIManager()
    
    private var newProductImages = [NewProductImage]()
    private var productImages: [UIImage] = [] {
        didSet {
            imageCollectionView.reloadData()
        }
    }

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
    
    private func setUpCollectionViewCell() {
        imageCollectionView = productRegisterView.productImageCollectionView
        imageCollectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
        imageCollectionView.register(ProductImageCellFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ProductImageCellFooterView.identifier)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
    }
    
    private func presentSuccessAlert() {
        let alert = UIAlertController(title: "상품등록 성공", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)

        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func presentFailureAlert() {
        let alert = UIAlertController(title: "상품등록 실패", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func addImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        let newImage = NewProductImage(fileName: "New.jpeg", data: imageData, type: "jpeg")
        productImages.append(image)
        newProductImages.append(newImage)
    }
    
    private func removeImage(at index: Int) {
        productImages.remove(at: index)
        newProductImages.remove(at: index)
    }
    
    private func checkProductName() -> String {
        guard let name = productRegisterView.productNameTextField.text else { return "" }
        
        return name
    }
    
    private func checkProductDescription() -> String {
        guard let description = productRegisterView.productDescriptionTextView.text, description.count >= 100 else { return "" }
        
        return description
    }
    
    private func checkProductPrice() -> Double {
        guard let priceText = productRegisterView.priceTextField.text, !priceText.isEmpty,
              let price = Double(priceText) else { return 0 }
        
        return price
    }
    
    private func checkProductDiscountedPrice() -> Double {
        guard let discountedPriceText = productRegisterView.discountPriceTextField.text,
              let discountedPrice = Double(discountedPriceText) else { return 0 }
        
        return discountedPrice
    }
    
    private func checkProductCurrency() -> Currency {
        let selectedIndex = productRegisterView.currencySegmentedControl.selectedSegmentIndex
        guard let currencyTitle = productRegisterView.currencySegmentedControl.titleForSegment(at: selectedIndex),
              let currency = Currency.init(rawValue: currencyTitle) else { return Currency.won }
        
        return currency
    }
    
    private func checkProductStock() -> Int {
        guard let stockText = productRegisterView.stockTextField.text, !stockText.isEmpty,
              let stock = Int(stockText) else { return 0 }
        
        return stock
    }
    
    private func registerProductInformation() -> NewProductInformation {
        let name = checkProductName()
        let description = checkProductDescription()
        let price = checkProductPrice()
        let currency = checkProductCurrency()
        let discountedPrice = checkProductDiscountedPrice()
        let stock = checkProductStock()
        
        let info = NewProductInformation(name: name, descriptions: description, price: price, currency: currency, discountedPrice: discountedPrice, stock: stock, secret: "&T#X9cz!cq6fFSy6")
        
        return info
    }
    
    private func registerNewProduct(with information: NewProductInformation) {
        api.registerProduct(information: information, image: newProductImages) { result in
            switch result {
            case .success(let data):
                NotificationCenter.default.post(name: .updateView, object: nil)
                DispatchQueue.main.async {
                    self.presentSuccessAlert()
                }
            case .failure(let error):
                self.presentFailureAlert()
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - @objc method
    @objc func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapDoneButton() {
        let information = registerProductInformation()
        registerNewProduct(with: information)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapAddButton() {
        let alert = UIAlertController(title: "상품사진 선택", message: nil, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) { action in
            self.presentLibrary()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { action in
            self.presentCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [library, camera, cancel].forEach { action in
            alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - CollectionViewDataSource, Delegate method
extension ProductRegisterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier, for: indexPath) as? ProductImageCell else {
            return ProductImageCell()
        }
        
        cell.setUpProductImage(with: productImages[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProductImageCellFooterView.identifier, for: indexPath) as? ProductImageCellFooterView else {
            return UICollectionReusableView()
        }
        
        footerView.addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        return footerView
    }
}

// MARK: - ImagePickerControllerDelegate method
extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            productImagePicker.sourceType = .camera
            productImagePicker.allowsEditing = true
            productImagePicker.cameraFlashMode = .on
            present(productImagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    
    private func presentLibrary() {
        productImagePicker.sourceType = .photoLibrary
        productImagePicker.allowsEditing = true
        
        present(productImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImage(image: image)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
