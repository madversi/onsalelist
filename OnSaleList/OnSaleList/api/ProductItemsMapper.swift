//
//  ProductItemsMapper.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 06/06/23.
//

import Foundation

final class ProductItemsMapper {
    private struct Root: Decodable {
        let products: [Item]
        
        var productsList: [ProductItem] {
            return products.map { $0.productItem }
        }
    }

    private struct Item: Decodable {
        let name: String
        let image: URL?
        let regularPrice: String
        let onSale: Bool
        let actualPrice: String
        let sizes: [ItemSize]
        
        var productItem: ProductItem {
            return ProductItem(
                name: name,
                imageURL: image,
                price: regularPrice,
                onSale: onSale,
                salePrice: actualPrice,
                sizes: sizes.map { $0.productSize }
            )
        }
        
        private enum CodingKeys: String, CodingKey {
            case name, image, sizes
            case regularPrice = "regular_price"
            case onSale = "on_sale"
            case actualPrice = "actual_price"
        }
    }

    private struct ItemSize: Decodable {
        let size: String
        let available: Bool
        
        var productSize: Size {
            return Size(size: size, available: available)
        }
    }

    static func map(_ data: Data, _ response: HTTPURLResponse) ->  RemoteProductsLoader.Result{
        guard response.statusCode == 200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(.invalidData)
        }

        return .success(root.productsList)
    }
}
