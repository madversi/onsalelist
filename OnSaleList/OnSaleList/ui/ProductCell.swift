//
//  ProductCell.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 07/06/23.
//

import UIKit

class ProductCell: UITableViewCell {
    
    static let reuseIdentifier = "ProductCell"
    
    var viewModel: ProductCellViewModel?
    
    // MARK: - Outlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productOnSaleLabel: UILabel!
    @IBOutlet weak var productSalePriceLabel: UILabel!
    @IBOutlet weak var productAvailableSizesLabel: UILabel!
    
    // MARK: - Setup
    func configureProductCell(with productCellViewModel: ProductCellViewModel) {
        viewModel = productCellViewModel
        productImageView.image = viewModel?.image
        productNameLabel.text = viewModel?.name
        productPriceLabel.text = viewModel?.price
        productOnSaleLabel.text = viewModel?.onSale
        productAvailableSizesLabel.text = viewModel?.availableSizes
    }
    
    @IBAction func didTapAddToCartButton() {
        viewModel?.addToCartAction()
    }
    
}

class ProductCellViewModel {
    let image: UIImage
    let name: String
    let price: String
    let onSale: String
    let salePrice: String
    let availableSizes: String
    let addToCartAction: () -> Void
    
    init(image: UIImage, name: String, price: String, onSale: String, salePrice: String, availableSizes: String, addToCartAction: @escaping () -> Void) {
        self.image = image
        self.name = name
        self.price = price
        self.onSale = onSale
        self.salePrice = salePrice
        self.availableSizes = availableSizes
        self.addToCartAction = addToCartAction
    }
}
