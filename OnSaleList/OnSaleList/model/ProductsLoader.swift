//
//  ProductsLoader.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 01/06/23.
//

import Foundation

public enum LoadProductsResult {
    case success([ProductItem])
    case failure(Error)
}

public protocol ProductsLoader {
    func load(completion: @escaping (LoadProductsResult) -> Void)
}
