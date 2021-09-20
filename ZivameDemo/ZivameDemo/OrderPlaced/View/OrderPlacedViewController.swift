//
//  OrderPlacedViewController.swift
//  ZivameDemo
//
//  Created by Ashutos on 9/20/21.
//

import UIKit
import MBProgressHUD

class OrderPlacedViewController: UIViewController {

    
    private let viewModel =  OrderPlacedViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            guard let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
            self.viewModel.processOrderPlaced(moc: managedObjectContext) { [ weak self] (isOrderPlaced) in
                MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
                if isOrderPlaced {
                    self?.navigationController?.popToRootViewController(animated: true)
                } else {
                    print("Something went wrong")
                }
            }
        }
    }
}
