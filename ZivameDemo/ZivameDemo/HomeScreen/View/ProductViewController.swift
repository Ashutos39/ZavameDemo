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
    //cart and checkout
    @IBOutlet weak var cartProductCountLabel: UILabel!
    
    @IBOutlet weak var checkoutButton: UIButton!
    
    private let productViewModel = ProductViewModel()
    private let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        productViewModel.getProductFromAPI { [weak self] (receivedResponse) in
            if receivedResponse {
                self?.productTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productViewModel.fetchAddedProductsFromCart { (isFetched) in
            self.productTableView.reloadData()
        }
    }
    
    @IBAction func segmentDidChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        productViewModel.currentSegmentIndex = sender.selectedSegmentIndex
        productTableView.reloadData()
    }
    
    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
        
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
        let product = productViewModel.getFilteredProductDetails()[indexPath.row]
        productCell.updateUI(product: product, isAddedToCart: productViewModel.isProductAlreadyAddedToCart(product: product))
        productCell.selectionStyle = .none
       return productCell
    }
}

extension ProductViewController: ProductTableViewCellDelegate {
    func addProduct(withSelectedIndex index: Int) {
        let product = productViewModel.getFilteredProductDetails()[index]
        productViewModel.addProductToCoreData(productDetails: product) { (isSavedToCoreData) in
            if isSavedToCoreData {
                productTableView.reloadData()
            }
        }
        
    }
    
    func removeProduct(withSelectedIndex index: Int) {
        let product = productViewModel.getFilteredProductDetails()[index]
        productTableView.reloadData()
    }
}

private extension ProductViewController {
    func registerCell() {
       productTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
   }
}

extension UIViewController {
    func showAlert(withTitleMessageAndAction title:String, message:String , action: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if action {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action : UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))
        } else{
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
}
