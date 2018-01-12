//
//  CategoriesPresenter.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol CategoriesView: class {
    func reloadTable()
    func setNoNetworkNoCacheView()
}

class CategoriesPresenter {
    var categories = [Category]()
    weak var view: CategoriesView?

    func requestBookCategories() {
        retrieveStoredCategories()
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
    
    private func retrieveStoredCategories() {
        if let data = UserDefaults.standard.object(forKey: CategoriesConstants.categories) as? Data,
            let categories = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Category] {
            self.categories = categories
            print("setting categories")
        } else {
            //helps prevent a flicker
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.view?.setNoNetworkNoCacheView()
            })
        }
        view?.reloadTable()
    }
    
    private func storeCategories() {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: categories)
        UserDefaults.standard.set(encodedData, forKey: CategoriesConstants.categories)
    }
    
    private func parseCategories(results: [JSON]) {
        results.forEach { result in
            let listName = result["list_name"].stringValue
            let encodedName = result["list_name_encoded"].stringValue
            let category = Category(listName: listName, encodedName: encodedName)
            self.categories.append(category)
        }
        
        storeCategories()
        view?.reloadTable()
    }
}
