//
//  CategoriesPresenter.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import Foundation
import SwiftyJSON

//Allows communication between the presenter and CategoriesViewController
protocol CategoriesView: class {
    func reloadTable()
    func setNoNetworkNoCacheView()
}

class CategoriesPresenter {
    var categories = [Category]()
    weak var view: CategoriesView?
    
    
    /**
        This method will request the book categories from the NYT API
     - returns: Void
     */
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
    
    /**
        This method retrieves the stored categories from UserDefaults for when there's no network connection
     - returns: Void
     */
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
    
    /**
     This method stores the categories from UserDefaults for when there's no network connection
     - returns: Void
     */
    private func storeCategories() {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: categories)
        UserDefaults.standard.set(encodedData, forKey: CategoriesConstants.categories)
    }
    
    /**
        This method parses call the categories and stores them in cache
     - parameter results: results from NYT API in JSON format
     - returns: Void
     */
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
