//
//  ProductViewController.swift
//  ZivameDemo
//
//  Created by Ashutos on 9/19/21.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var productTableView: UITableView!
    
    private let productViewModel = ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        
        productViewModel.getProductFromAPI { [weak self] (receivedResponse) in
            if receivedResponse {
                self?.productTableView.reloadData()
            }
        }
    }
    
    @IBAction func segmentDidChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
       
    }
    
    private func registerCell() {
        productTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
    }
}

extension ProductViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productViewModel.getFilteredProductDetails().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let productCell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else { return UITableViewCell()}
        productCell.cellDelegate = self
        productCell.prductSelectionButton.tag = indexPath.row
        productCell.updateUI(product: productViewModel.allProductData[indexPath.row])
       return productCell
    }
}

extension ProductViewController: ProductTableViewCellDelegate {
    func selectionButtonPressed(withSelectedIndex index: Int) {
        productTableView.reloadData()
    }
}
