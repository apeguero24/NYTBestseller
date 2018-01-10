//
//  CategoriesPresenter.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import Foundation
import SwiftyJSON

class CategoriesPresenter {
    var categories = [Category]()
    
    func requestBookCategories() {
        NYTNetwork.default.request(target: .listNames, success: { (data) in
            let json = JSON(data as Any)
            let results = json["results"].arrayValue
            self.parseCategories(results: results)
        }, error: { (error) in
            print(error)
        }) { (failure) in
            print(failure)
        }
    }
    
    private func parseCategories(results: [JSON]) {
        results.forEach { result in
            let listName = result["list_name"].stringValue
            let encodedName = result["list_name_encoded"].stringValue
            let category = Category(listName: listName, encodedName: encodedName)
            self.categories.append(category)
        }
    }
}
