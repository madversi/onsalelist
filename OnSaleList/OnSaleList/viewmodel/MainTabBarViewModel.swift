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
    
    private func notifyCartProductsUpdate() {
        cartPublisher.send(cartProducts)
    }
    
    private init() { }
}
