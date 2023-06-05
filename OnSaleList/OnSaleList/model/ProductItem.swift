//
//  ProductItem.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 01/06/23.
//

import Foundation

public struct Size: Equatable, Decodable {
    public let size: String
    public let available: Bool
    
    public init(size: String, available: Bool) {
        self.size = size
        self.available = available
    }
}

public struct ProductItem: Equatable {
    public let name: String
    public let imageURL: URL?
    public let price: String
    public let onSale: Bool
    public let salePrice: String
    public let sizes: [Size]
    
    public init(name: String, imageURL: URL?, price: String, onSale: Bool, salePrice: String, sizes: [Size]) {
        self.name = name
        self.imageURL = imageURL
        self.price = price
        self.onSale = onSale
        self.salePrice = salePrice
        self.sizes = sizes
    }
}

extension ProductItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name, sizes
        case imageURL = "image"
        case price = "regular_price"
        case onSale = "on_sale"
        case salePrice = "actual_price"
    }
}
