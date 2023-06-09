//
//  MainTabBarViewModel.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 08/06/23.
//

import Combine
import Foundation

final class MainTabBarViewModel {
    
    public var products = [ProductItem]()
    static let shared = MainTabBarViewModel()
    
    let productsInCartPublisher = PassthroughSubject<[ProductItem], Never>()
    var productsInCart: [ProductItem] = [] {
        didSet {
            productsInCartPublisher.send(productsInCart)
        }
    }
    
    private init() { }
}
