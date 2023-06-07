//
//  ProductCell.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 07/06/23.
//

import Kingfisher
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
        setupImageView()
        productNameLabel.text = viewModel?.name
        productPriceLabel.text = viewModel?.price
        productOnSaleLabel.text = viewModel?.onSale
        productSalePriceLabel.text = viewModel?.salePrice
        productAvailableSizesLabel.text = viewModel?.availableSizes
    }
    
    @IBAction func didTapAddToCartButton() {
        viewModel?.addToCartAction()
    }
    
    // Will be moved to a proper location in the next PRs
    private func setupImageView() {
        guard let url = viewModel?.image else {
            productImageView.image = UIImage(named: "Placeholder")
            return
        }
        
        let processor = DownsamplingImageProcessor(size: productImageView.bounds.size)
        productImageView.kf.indicatorType = .activity
        productImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}

class ProductCellViewModel {
    let image: URL?
    let name: String
    let price: String
    let onSale: String
    let salePrice: String
    let availableSizes: String
    let addToCartAction: () -> Void
    
    init(image: URL?, name: String, price: String, onSale: String, salePrice: String, availableSizes: String, addToCartAction: @escaping () -> Void) {
        self.image = image
        self.name = name
        self.price = price
        self.onSale = onSale
        self.salePrice = salePrice
        self.availableSizes = availableSizes
        self.addToCartAction = addToCartAction
    }
}
