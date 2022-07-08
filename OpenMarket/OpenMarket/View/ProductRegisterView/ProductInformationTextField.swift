//
//  ProductInformationTextField.swift
//  OpenMarket
//
//  Created by Allie on 2022/06/26.
//

import UIKit

class ProductInformationTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.clearButtonMode = .always
    }
}
