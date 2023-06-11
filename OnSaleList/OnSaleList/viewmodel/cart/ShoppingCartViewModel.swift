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
    var currentCartProduct: CartProduct?
    
    init() {
        mainTabBarProductsObserver = MainTabBarViewModel.shared.cartPublisher.sink(receiveValue: { [weak self] products in
            self?.productsInCart = products
        })
    }
    
    func makeCellViewModel(with cartProduct: CartProduct) -> ShoppingCartCellViewModel {
        currentCartProduct = cartProduct
        let shoppingCartCellViewModel = ShoppingCartCellViewModel(
            image: cartProduct.image,
            name: cartProduct.name,
            price: cartProduct.price,
            quantity: cartProduct.quantity,
            removeAction: { [weak self] in
                self?.removeFromCart()
            },
            addAction: { [weak self] in
                self?.increaseQuantity()
            },
            removeAllAction: { [weak self] in
                self?.removeAllFromCart()
            }
        )
        return shoppingCartCellViewModel
    }
    
    func refreshCartData() {
        productsInCartPublisher.send(productsInCart)
    }
    
    private func removeFromCart() {
        if let item = currentCartProduct {
            MainTabBarViewModel.shared.removeItemFromCart(item)
        }
    }
    
    private func increaseQuantity() {
        if let item = currentCartProduct {
            MainTabBarViewModel.shared.addItemToCart(item)
        }
    }
    
    private func removeAllFromCart() {
        if let item = currentCartProduct {
            MainTabBarViewModel.shared.removeItemFromCart(item, shouldRemoveAll: true)
        }
    }
    
}
