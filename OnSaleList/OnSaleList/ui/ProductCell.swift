//
//  ProductCell.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 07/06/23.
//

import UIKit

class ProductCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productOnSaleLabel: UILabel!
    @IBOutlet weak var productSalePriceLabel: UILabel!
    @IBOutlet weak var productAvailableSizesLabel: UILabel!
    
    // MARK: - Setup
    func configureProductCell(with productCellViewModel: ProductCellViewModel) {
        productImageView.image = productCellViewModel.image
        productNameLabel.text = productCellViewModel.name
        productPriceLabel.text = productCellViewModel.price
        productOnSaleLabel.text = productCellViewModel.onSale
        productAvailableSizesLabel.text = productCellViewModel.availableSizes
    }
    
    @IBAction func didTapAddToCartButton() {
//        delegate.didTapAddToCartButton()
    }
    
}

class ProductCellViewModel {
    let image: UIImage
    let name: String
    let price: String
    let onSale: String
    let salePrice: String
    let availableSizes: String
    
    init(image: UIImage, name: String, price: String, onSale: String, salePrice: String, availableSizes: String) {
        self.image = image
        self.name = name
        self.price = price
        self.onSale = onSale
        self.salePrice = salePrice
        self.availableSizes = availableSizes
    }
}
