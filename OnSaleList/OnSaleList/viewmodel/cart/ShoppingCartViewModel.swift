//
//  ShoppingCartViewModel.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 08/06/23.
//

import Combine
import Foundation

final class ShoppingCartViewModel {
    
    let productsInCartPublisher = PassthroughSubject<[CartProduct], Never>()
    private (set) var productsInCart: [CartProduct] = [] {
        didSet {
            refreshCartData()
        }
    }
    
    var mainTabBarProductsObserver: AnyCancellable?
    
    init() {
        mainTabBarProductsObserver = MainTabBarViewModel.shared.cartPublisher.sink(receiveValue: { [weak self] products in
            self?.productsInCart = products
        })
    }
    
    func makeCellViewModel(with cartProduct: CartProduct) -> ShoppingCartCellViewModel {
        let shoppingCartCellViewModel = ShoppingCartCellViewModel(
            image: cartProduct.image,
            name: cartProduct.name,
            price: cartProduct.price,
            quantity: cartProduct.quantity
        )
        return shoppingCartCellViewModel
    }
    
    func refreshCartData() {
        productsInCartPublisher.send(productsInCart)
    }
    
}
