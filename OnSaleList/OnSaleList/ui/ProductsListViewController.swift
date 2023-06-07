//
//  ProductsListViewController.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 01/06/23.
//

import UIKit

class ProductsListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    static let productsLoader = RemoteProductsLoader(url: URL(string: "https://www.mocky.io/v2/59b6a65a0f0000e90471257d")!, client: URLSessionHTTPClient())
    
    var products = [ProductItem]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProductCellView", bundle: nil), forCellReuseIdentifier: ProductCell.reuseIdentifier)
        
        ProductsListViewController.productsLoader.load { [weak self] result in
            switch result {
            case let .success(products):
                self?.products = products
            case let .failure(error):
                print(error)
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }
    
}

extension ProductsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseIdentifier, for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }
        let productItem = products[indexPath.row]
        
        let cellViewModel = ProductCellViewModel(image: UIImage(), name: productItem.name, price: productItem.price, onSale: productItem.onSale.description, salePrice: productItem.salePrice, availableSizes: productItem.sizes.map { $0.size }.description) {
            print(productItem.name)
        }
        
        cell.configureProductCell(with: cellViewModel)
        return cell
    }
    
}
