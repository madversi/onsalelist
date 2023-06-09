//
//  ShoppingCartViewController.swift
//  OnSaleList
//
//  Created by Helder Marcelo Adversi Junior on 08/06/23.
//

import Combine
import UIKit

class ShoppingCartViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalInCartLabel: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
        
    // MARK: - Properties
    private var viewModel = ShoppingCartViewModel()
    private var productsInChart: [CartProduct] = [] {
        didSet { tableView.reloadData() }
    }
    private var observer: AnyCancellable?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ShoppingCartCellView", bundle: nil), forCellReuseIdentifier: ShoppingCartCell.reuseIdentifier)
        observer = viewModel.productsInCartPublisher.sink { [weak self] products in
            self?.productsInChart = products
        }
        viewModel.refreshCartData()
    }
    
}

extension ShoppingCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productsInChart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingCartCell.reuseIdentifier, for: indexPath) as? ShoppingCartCell else {
            return UITableViewCell()
        }

        let item = productsInChart[indexPath.row]
        let cellViewModel = viewModel.makeCellViewModel(with: item)
        
        cell.configureProductCell(with: cellViewModel)
        return cell
    }
    
}
