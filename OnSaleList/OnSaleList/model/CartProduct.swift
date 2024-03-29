//
//  CartProduct.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 09/06/23.
//

import Foundation

class CartProduct {
    let image: URL?
    let name: String
    let price: String
    var quantity: Int
    var minusAction: () -> Void
    var plusAction: () -> Void
    var removeAllAction: () -> Void
    
    init(image: URL?, name: String, price: String, quantity: Int, minusAction: @escaping () -> Void, plusAction: @escaping () -> Void, removeAllAction: @escaping () -> Void) {
        self.image = image
        self.name = name
        self.price = price
        self.quantity = quantity
        self.minusAction = minusAction
        self.plusAction = plusAction
        self.removeAllAction = removeAllAction
    }
    
    static func makeCartItem(from productItem: ProductItem) -> CartProduct {
        let price = productItem.onSale ? productItem.salePrice : productItem.price
        return CartProduct(
            image: productItem.imageURL,
            name: productItem.name,
            price: price,
            quantity: 1,
            minusAction: {
                
            },
            plusAction: {
                
            },
            removeAllAction: {
                
            }
        )
    }
}

extension CartProduct: Equatable {
    static func == (lhs: CartProduct, rhs: CartProduct) -> Bool {
        return lhs.name == rhs.name &&
        lhs.price == rhs.price
    }
}
