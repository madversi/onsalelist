//
//  ProductsListViewModel.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 07/06/23.
//

import UIKit

protocol ProductsListViewModelDelegate: AnyObject {
    func onFetchProductsSuccess()
    func onFetchProductsFailure(errorDescription: String)
}

final class ProductsListViewModel {
    
    private static let API_URL = "https://www.mocky.io/v2/59b6a65a0f0000e90471257d"
    private let remoteProductsLoader: RemoteProductsLoader
    
    var productsList: [ProductItem] {
        MainTabBarViewModel.shared.products
    }

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
                MainTabBarViewModel.shared.products = products
                self?.delegate?.onFetchProductsSuccess()
            case let .failure(error):
                self?.delegate?.onFetchProductsFailure(errorDescription: error.localizedDescription)
            }
        }
    }
    
    func makeCellViewModel(with productItem: ProductItem) -> ProductCellViewModel {
        var regularPriceText = productItem.price
        var onSaleText = ""
        var salePriceText = ""
        if productItem.onSale {
            regularPriceText = ""
            onSaleText = "Exclusive offer! From \(productItem.price) to:"
            salePriceText = productItem.salePrice
        }
        
        let availableSizesText = makeSizesString(from: productItem.sizes)
        
        let productCellViewModel = ProductCellViewModel(
            image: productItem.imageURL,
            name: productItem.name,
            price: regularPriceText,
            onSale: onSaleText,
            salePrice: salePriceText,
            availableSizes: availableSizesText,
            addToCartAction: { [weak self] in
                self?.addToCart(item: productItem)
            }
        )
        return productCellViewModel
    }
    
    private func addToCart(item: ProductItem) {
        MainTabBarViewModel.shared.productsInCart.append(item)
    }
    
    private func makeSizesString(from sizesArray: [Size]) -> String {
        var sizesString = "Available in: "
        sizesString += sizesArray.compactMap {
            $0.available ? $0.size : nil
        }.joined(separator: ", ")
        
        return sizesString
    }
    
}
