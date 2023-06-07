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
    private var viewModel = ProductsListViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProductCellView", bundle: nil), forCellReuseIdentifier: ProductCell.reuseIdentifier)
        viewModel.fetchProducts()
    }
    
}

extension ProductsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.productsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseIdentifier, for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }
        
        let products = viewModel.productsList
        let productItem = products[indexPath.row]
        
        let cellViewModel = ProductCellViewModel(image: UIImage(), name: productItem.name, price: productItem.price, onSale: productItem.onSale.description, salePrice: productItem.salePrice, availableSizes: productItem.sizes.map { $0.size }.description) {
            print(productItem.name)
        }
        
        cell.configureProductCell(with: cellViewModel)
        return cell
    }
    
}

extension ProductsListViewController: ProductsListViewModelDelegate {
    func onFetchProductsSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func onFetchProductsFailure(errorDescription: String) {
        UIAlertController(title: "Error!", message: "Got error: \(errorDescription)", preferredStyle: .alert).show(self, sender: nil)
    }
}
