//
//  ShoppingCartViewModel.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 08/06/23.
//

import Combine
import Foundation

final class ShoppingCartViewModel {
    
    let productsInCartPublisher = PassthroughSubject<[ProductItem], Never>()
    private (set) var productsInCart: [ProductItem] = [] {
        didSet {
            productsInCartPublisher.send(productsInCart)
        }
    }
    
    var mainTabBarProductsObserver: AnyCancellable?
    
    init() {
        mainTabBarProductsObserver = MainTabBarViewModel.shared.productsInCartPublisher.sink(receiveValue: { [weak self] products in
            self?.productsInCart = products
        })
    }
    
    func makeCellViewModel(with productItem: ProductItem) -> ShoppingCartCellViewModel {
        let shoppingCartCellViewModel = ShoppingCartCellViewModel(
            image: productItem.imageURL,
            name: productItem.name,
            price: productItem.price,
            quantity: "2"
        )
        return shoppingCartCellViewModel
    }
}
