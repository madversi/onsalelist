//
//  ProductsListViewModel.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 07/06/23.
//

import Foundation

protocol ProductsListViewModelDelegate: AnyObject {
    func onFetchProductsSuccess()
    func onFetchProductsFailure(errorDescription: String)
}

final class ProductsListViewModel {
    
    private static let API_URL = "https://www.mocky.io/v2/59b6a65a0f0000e90471257d"
    private let remoteProductsLoader: RemoteProductsLoader
    
    var productsList = [ProductItem]()
    weak var delegate: ProductsListViewModelDelegate?
    
    init() {
        let apiURL = URL(string: ProductsListViewModel.API_URL)!
        let httpClient = URLSessionHTTPClient()
        remoteProductsLoader = RemoteProductsLoader(url: apiURL, client: httpClient)
    }
    
    func fetchProducts() {
        remoteProductsLoader.load { [weak self] result in
            switch result {
            case let .success(products):
                self?.productsList = products
                self?.delegate?.onFetchProductsSuccess()
            case let .failure(error):
                self?.delegate?.onFetchProductsFailure(errorDescription: error.localizedDescription)
            }
        }
        
    }
    
}
