//
//  CheckOutViewController.swift
//  ZivameDemo
//
//  Created by Ashutos on 9/20/21.
//

import UIKit
import MBProgressHUD

protocol  CheckOutViewControllerDelegate {
    func checkoutPressed()
}

class CheckOutViewController: UIViewController {

    private let viewModel =  CheckOutViewModel()

    @IBOutlet weak var checkoutTableview: UITableView!
    @IBOutlet weak var checkoutButton: UIButton! {
        didSet{
        checkoutButton.layer.cornerRadius = 5.0
        checkoutButton.backgroundColor = .lightGray
        }
    }
    
    var delegate: CheckOutViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        // Do any additional setup after loading the view.
    }
    
    func initData(cartData: [ProductInCart]) {
        viewModel.addedProductsInCart = cartData
    }
    
    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
        if viewModel.addedProductsInCart.isEmpty {// show alert
            showAlert(withTitleMessageAndAction: "Warning!!!", message: " Please add products to checkout", action: false)
        } else {// move to checkout screen
            delegate?.checkoutPressed()
        }
    }
}

extension CheckOutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.addedProductsInCart.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let productCell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else { return UITableViewCell()}
        productCell.cellDelegate = self
        productCell.prductSelectionButton.tag = indexPath.row
        let cartProduct = viewModel.addedProductsInCart[indexPath.row]
        let product = Product(name: cartProduct.name, price: cartProduct.price, imageURL: cartProduct.imageUrl, rating: Int(cartProduct.rating))
        productCell.updateUI(product: product, isAddedToCart: true)
        productCell.selectionStyle = .none
       return productCell
    }    
}

extension CheckOutViewController : ProductTableViewCellDelegate {
    func addProduct(withSelectedIndex index: Int) {}
    
    func removeProduct(withSelectedIndex index: Int) {
        let cartProduct = viewModel.addedProductsInCart[index]
        let product = Product(name: cartProduct.name, price: cartProduct.price, imageURL: cartProduct.imageUrl, rating: Int(cartProduct.rating))
        guard let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        viewModel.removeProductFromCoreData(managedObjectContext: managedObjectContext, product: product) { (isRemoved) in
            checkoutTableview.reloadData()
            if viewModel.addedProductsInCart.isEmpty {
                showAlert(withTitleMessageAndAction: "Warning!!!", message: " Please add products to checkout", action: true)
            }
        }
    }
    
    func registerCell() {
        checkoutTableview.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
   }
}
