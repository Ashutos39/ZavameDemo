//
//  CheckOutViewModel.swift
//  ZivameDemo
//
//  Created by Ashutos on 9/20/21.
//

import Foundation
import CoreData

class CheckOutViewModel {
    
    var addedProductsInCart = [ProductInCart]()
    
    func removeProductFromCoreData(managedObjectContext: NSManagedObjectContext,product: Product, removeCompletionHandler: (Bool) -> Void) {// Remove product from cart
        if let index = addedProductsInCart.firstIndex(where: {$0.name == product.name}) {
            
            managedObjectContext.delete(addedProductsInCart[index] as NSManagedObject)
            addedProductsInCart.remove(at: index)
            let _ : NSError! = nil
            do {
                try managedObjectContext.save()
                removeCompletionHandler(true)
            } catch {
                removeCompletionHandler(false)
                print("error : \(error)")
            }
        }
    }
}
