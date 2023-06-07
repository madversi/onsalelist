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
    @IBOutlet weak var addToChartButton: UIButton!
    
    // MARK: - Setup
    func configureProductCell(with productCellViewModel: ProductCellViewModel) {
        
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
