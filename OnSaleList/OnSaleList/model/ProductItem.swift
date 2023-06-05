//
//  ProductItem.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 01/06/23.
//

import Foundation

struct Size: Equatable {
    let size: String
    let available: Bool
}

public struct ProductItem: Equatable {
    let name: String
    let imageURL: URL?
    let price: String
    let onSale: Bool
    let salePrice: String
    let sizes: [Size]
}
