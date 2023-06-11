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
    let cartSumPublisher = PassthroughSubject<String, Never>()
    
    private var cartProducts: [CartProduct] = [] {
        didSet {
            getTotalCartItemsPrice()
        }
    }
    private var cartTotalSum: String = "" {
        didSet {
            notifyCartTotalSumUpdated()
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
    
    private func getTotalCartItemsPrice() {
        let moneyArray = cartProducts.map { item in
            stringToMoney(item.price, quantity: item.quantity)
        }.compactMap {$0}
        
        let sum = moneyArray.reduce(0, +)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "pt_BR")
        
        cartTotalSum = numberFormatter.string(from: sum as NSNumber) ?? ""
    }
    
    private func notifyCartTotalSumUpdated() {
        cartSumPublisher.send(cartTotalSum)
    }
    
    private func stringToMoney(_ string: String, quantity: Int) -> Decimal? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "pt_BR")
        
        guard let number = numberFormatter.number(from: string.replacingOccurrences(of: " ", with: "")) else {
            return nil
        }
        
        return number.decimalValue * Decimal(quantity)
    }
    
    private func notifyCartProductsUpdate() {
        getTotalCartItemsPrice()
        cartPublisher.send(cartProducts)
    }
    
    private init() { }
}
