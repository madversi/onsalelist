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
    var cartProducts: [CartProduct] = [] {
        didSet {
            notifyCartProductsUpdate()
        }
    }
    
    func addItemToCart(_ item: CartProduct) {
        guard !cartProducts.contains(item) else {
            let elementIndex = cartProducts.firstIndex(of: item)!
            cartProducts[elementIndex].quantity += 1
            notifyCartProductsUpdate()
            return
        }
        cartProducts.append(item)
    }
    
    private func notifyCartProductsUpdate() {
        cartPublisher.send(cartProducts)
    }
    
    private init() { }
}
