//
//  MainTabBarViewModel.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 08/06/23.
//

import Combine
import Foundation

final class MainTabBarViewModel {
    
    var products = [ProductItem]()
    static let shared = MainTabBarViewModel()
    
    let cartPublisher = PassthroughSubject<[CartProduct], Never>()
    
    private var cartProducts: [CartProduct] = []
    
    func addItemToCart(_ item: CartProduct) {
        guard !cartProducts.contains(item) else {
            let elementIndex = cartProducts.firstIndex(of: item)!
            cartProducts[elementIndex].quantity += 1
            notifyCartProductsUpdate()
            return
        }
        cartProducts.append(item)
        notifyCartProductsUpdate()
    }
    
    func removeItemFromCart(_ item: CartProduct, shouldRemoveAll: Bool = false) {
        guard cartProducts.contains(item),
              let elementIndex = cartProducts.firstIndex(of: item) else {
            notifyCartProductsUpdate()
            return
        }
        
        if shouldRemoveAll {
            cartProducts.remove(at: elementIndex)
            notifyCartProductsUpdate()
            return
        }
        
        let quantity = cartProducts[elementIndex].quantity
        
        if quantity > 1 {
            cartProducts[elementIndex].quantity -= 1
        } else {
            cartProducts.remove(at: elementIndex)
        }
        notifyCartProductsUpdate()
        
    }
    
    private func notifyCartProductsUpdate() {
        cartPublisher.send(cartProducts)
    }
    
    private init() { }
}
