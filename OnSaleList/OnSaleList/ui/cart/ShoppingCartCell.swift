//
//  ShoppingCartCell.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 08/06/23.
//

import Kingfisher
import UIKit

class ShoppingCartCell: UITableViewCell {
    
    static let reuseIdentifier = "ShoppingCartCell"
    var viewModel: ShoppingCartCellViewModel?
    
    // MARK: - Outlets
    @IBOutlet weak var shoppingCartImageView: UIImageView!
    @IBOutlet weak var shoppingCartNameLabel: UILabel!
    @IBOutlet weak var shoppingCartPriceLabel: UILabel!
    @IBOutlet weak var shoppingCartQuantityLabelData: UILabel!
    @IBOutlet weak var shoppingCartMinusButton: UIButton!
    
    // MARK: - Setup
    func configureProductCell(with shoppingCartCellViewModel: ShoppingCartCellViewModel) {
        viewModel = shoppingCartCellViewModel
        setupImageView()
        shoppingCartNameLabel.text = viewModel?.name
        shoppingCartPriceLabel.text = viewModel?.price
        shoppingCartQuantityLabelData.text = viewModel?.quantity
        let isMinusButtonEnabled = viewModel?.enableMinusButton ?? true
        shoppingCartMinusButton.isEnabled = isMinusButtonEnabled
    }
    
    // MARK: - Button actions
    @IBAction func didTapMinusButton(_ sender: Any) {
        viewModel?.removeAction()
    }
    
    @IBAction func didTapPlusButton(_ sender: Any) {
        viewModel?.addAction()
    }
    
    @IBAction func didTapRemoveAllButton(_ sender: Any) {
        viewModel?.removeAllAction()
    }
    
    //TODO: Will be moved to a proper location in the next PRs
    private func setupImageView() {
        guard let url = viewModel?.image else {
            shoppingCartImageView.image = UIImage(named: "Placeholder")
            return
        }
        
        let processor = DownsamplingImageProcessor(size: shoppingCartImageView.bounds.size)
        shoppingCartImageView.kf.indicatorType = .activity
        shoppingCartImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}

class ShoppingCartCellViewModel {
    
    let image: URL?
    let name: String
    let price: String
    let quantity: String
    let enableMinusButton: Bool
    var removeAction: () -> Void
    var addAction: () -> Void
    var removeAllAction: () -> Void
    
    init(image: URL?, name: String, price: String, quantity: Int, enableMinusButton: Bool = true, removeAction: @escaping () -> Void, addAction: @escaping () -> Void, removeAllAction: @escaping () -> Void) {
        self.image = image
        self.name = name
        self.price = price
        self.quantity = quantity > 0 ? quantity.description : ""
        self.enableMinusButton = quantity > 0
        self.removeAction = removeAction
        self.addAction = addAction
        self.removeAllAction = removeAllAction
    }
    
}
