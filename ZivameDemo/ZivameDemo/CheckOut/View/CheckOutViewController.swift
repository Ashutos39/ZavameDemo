//
//  CheckOutViewController.swift
//  ZivameDemo
//
//  Created by Ashutos on 9/20/21.
//

import UIKit
import MBProgressHUD

class CheckOutViewController: UIViewController {

    private let viewModel =  CheckOutViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    private func setUpUI() {
        self.title = "Checkout"
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            guard let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
            self.viewModel.processOrderPlaced(moc: managedObjectContext) { [ weak self] (isOrderPlaced) in
                if isOrderPlaced {
                    self?.showAlert(withTitleMessageAndAction: "Sucess", message: "Thanks for your order.", action: true)
                } else {
                    print("Something went wrong")
                }
                MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
            }
        }
    }
}
