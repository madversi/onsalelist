//
//  ProductItem.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 01/06/23.
//

import Foundation

struct Size {
    let size: String
    let available: Bool
}

struct Product {
    let name: String
    let imageURL: URL?
    let price: String
    let onSale: Bool
    let salePrice: String
    let sizes: [Size]
}
