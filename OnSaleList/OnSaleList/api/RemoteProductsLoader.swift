//
//  RemoteProductsLoader.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 01/06/23.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteProductsLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([ProductItem])
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                if response.statusCode == 200,
                let root = try? JSONDecoder().decode(Root.self, from: data) {
                    completion(.success(root.products.map { $0.productItem }))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private struct Root: Decodable {
    let products: [Item]
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
