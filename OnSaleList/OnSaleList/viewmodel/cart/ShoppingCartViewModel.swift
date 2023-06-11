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
    
    let cartTotalPublisher = PassthroughSubject<String, Never>()
    private (set) var totalInCart: String = ""
    
    var mainTabBarProductsObserver: AnyCancellable?
    var totalInCartObserver: AnyCancellable?
    
    init() {
        mainTabBarProductsObserver = MainTabBarViewModel.shared.cartPublisher.sink(receiveValue: { [weak self] products in
            self?.productsInCart = products
        })
        
        totalInCartObserver = MainTabBarViewModel.shared.cartSumPublisher.sink(receiveValue: { [weak self] total in
            self?.totalInCart = total
            self?.updateTotalInCart()
        })
    }
    
    func makeCellViewModel(with cartProduct: CartProduct) -> ShoppingCartCellViewModel {
        let shoppingCartCellViewModel = ShoppingCartCellViewModel(
            image: cartProduct.image,
            name: cartProduct.name,
            price: cartProduct.price,
            quantity: cartProduct.quantity,
            removeAction: { [weak self] in
                self?.removeFromCart(cartProduct)
            },
            addAction: { [weak self] in
                self?.increaseQuantity(cartProduct)
            },
            removeAllAction: { [weak self] in
                self?.removeFromCart(cartProduct, removeAll: true)
            }
        )
        return shoppingCartCellViewModel
    }
    
    func refreshCartData() {
        productsInCartPublisher.send(productsInCart)
        cartTotalPublisher.send(totalInCart)
    }
    
    private func updateTotalInCart() {
        cartTotalPublisher.send(totalInCart)
    }
    
    private func removeFromCart(_ item: CartProduct, removeAll: Bool = false) {
        MainTabBarViewModel.shared.removeItemFromCart(item, shouldRemoveAll: removeAll)
    }
    
    private func increaseQuantity(_ item: CartProduct) {
        MainTabBarViewModel.shared.addItemToCart(item)
    }
}
