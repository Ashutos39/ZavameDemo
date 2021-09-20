//
//  ProductViewModel.swift
//  ZivameDemo
//
//  Created by Ashutos on 9/19/21.
//

import Foundation
import Alamofire


class ProductViewModel {
    
    var currentSegmentIndex = 0
    
    var allProductData = [Product]()
    
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
       return allProductData
    }
}

