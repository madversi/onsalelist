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
    let products = [ProductItem]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

