//
//  ProductViewModel.swift
//  ZivameDemo
//
//  Created by Ashutos on 9/19/21.
//

import Foundation
import Alamofire
import CoreData


class ProductViewModel {
    
    var currentSegmentIndex = 0
    
    var allProductData = [Product]()
    var addedProductsInCart = [ProductInCart]()
    
    func getProductFromAPI(completionHandler: @escaping (Bool) -> Void) {
        let urlString = "https://my-json-server.typicode.com/nancymadan/assignment/db"
        AF.request(urlString, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                guard let responseData = response.data else { return }
              do {
                let decoder = JSONDecoder()
                let productData = try decoder.decode(ProductDetails.self, from: responseData)
                self.allProductData = productData.products ?? []
                completionHandler(true)
            } catch let error {
                print(error)
            }
            case .failure( _):
                break
            }
        }
    }
    
    func getFilteredProductDetails() -> [Product] {
        switch currentSegmentIndex {
        case 1:
            return allProductData.filter( { Int($0.price ?? "0") ?? 0 > 1000} )
        default:
            return allProductData.filter( {Int($0.price ?? "0") ?? 0 <= 1000})
        }
    }
    
    func addProductToCoreData(productDetails: Product, completionHandler: (Bool) -> Void) {
        
       guard let managedObjectContext = (UIApplication.shared.delegate
                                            as? AppDelegate)?.persistentContainer.viewContext else { return }
        guard let entityDescription =
                NSEntityDescription.entity(forEntityName: "ProductInCart",in: managedObjectContext) else { return  }
        let product = ProductInCart(entity: entityDescription, insertInto: managedObjectContext)
        product.imageUrl = productDetails.imageURL
        product.name = productDetails.name
        product.price = productDetails.price
        product.rating = Int64(productDetails.rating ?? 0)
        do {
            try managedObjectContext.save()
            addedProductsInCart.append(product)
            completionHandler(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            completionHandler(false)
        }
    }
    
    func removeProductFromCoreData(product: Product) {
        
    }
    
    func fetchAddedProductsFromCart(fetchedCompletionHandler: (Bool) -> Void){
        guard let managedObjectContext = (UIApplication.shared.delegate
                                            as? AppDelegate)?.persistentContainer.viewContext else { return }
        let entityDescription = NSEntityDescription.entity(forEntityName: "ProductInCart",in: managedObjectContext)
        
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<ProductInCart> = ProductInCart.fetchRequest()
        fetchRequest.entity = entityDescription
        do {
            addedProductsInCart = try managedObjectContext.fetch(fetchRequest)
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func isProductAlreadyAddedToCart(product: Product) -> Bool {
        let currentProduct = addedProductsInCart.filter({ $0.name == product.name })
        return currentProduct.isEmpty
    }
}

