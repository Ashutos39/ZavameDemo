//
//  ProductTableViewCell.swift
//  ZivameDemo
//
//  Created by Ashutos on 9/19/21.
//

import UIKit
import Kingfisher

protocol ProductTableViewCellDelegate {
    func addProduct(withSelectedIndex index: Int)
    func removeProduct(withSelectedIndex index: Int)
}

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageview: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var prductSelectionButton: UIButton!
    
    var cellDelegate: ProductTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func productSelectionButton(_ sender: UIButton) {
        if prductSelectionButton.titleLabel?.text == "Add" {
            cellDelegate?.addProduct(withSelectedIndex: sender.tag)
        } else {
            cellDelegate?.removeProduct(withSelectedIndex: sender.tag)
        }
    }
    
    func updateUI(product: Product, isAddedToCart: Bool) {
        productNameLabel.text = product.name
        productPriceLabel.text = "₹ \(product.price ?? "0")"
        if let imageUrl = product.imageURL {
            productImageview.kf.setImage(with: URL(string: imageUrl))
        }
        if isAddedToCart {
            prductSelectionButton.setTitle("Remove", for: .normal)
        } else {
            prductSelectionButton.setTitle("Add", for: .normal)
        }
    }
    
}

private extension ProductTableViewCell {
    func setUpUI() {
        prductSelectionButton.backgroundColor = .lightGray
        prductSelectionButton.layer.cornerRadius = 5.0
    }
}
