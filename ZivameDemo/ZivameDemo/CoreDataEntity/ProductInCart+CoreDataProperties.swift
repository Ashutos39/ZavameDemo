//
//  ProductInCart+CoreDataProperties.swift
//  ZivameDemo
//
//  Created by Ashutos on 9/20/21.
//
//

import Foundation
import CoreData


extension ProductInCart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductInCart> {
        return NSFetchRequest<ProductInCart>(entityName: "ProductInCart")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var rating: Int64

}

extension ProductInCart : Identifiable {

}
