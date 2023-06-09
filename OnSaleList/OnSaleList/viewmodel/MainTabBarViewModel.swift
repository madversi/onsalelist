//
//  MainTabBarViewModel.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 08/06/23.
//

import Foundation

final class MainTabBarViewModel {
    
    public var products = [ProductItem]()
    public var productsInCart = [ProductItem]()
    
    static let shared = MainTabBarViewModel()
    
    private init() { }
}
