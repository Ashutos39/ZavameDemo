//
//  OrderPlacedViewModel.swift
//  ZivameDemo
//
//  Created by Ashutos on 9/20/21.
//

import Foundation
import CoreData

class OrderPlacedViewModel {
    func processOrderPlaced(moc: NSManagedObjectContext, completionHandler: (Bool) -> Void) {
       
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductInCart")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try moc.execute(deleteRequest)
            try moc.save()
            completionHandler(true)
        } catch {
            print ("There was an error")
            completionHandler(false)
        }
    }
}
