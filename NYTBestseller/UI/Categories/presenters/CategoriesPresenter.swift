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
    
    func requestBookCategories() {
        NYTNetwork.default.request(target: .listNames, success: { (data) in
            let json = JSON(data as Any)
            print(json["results"].arrayValue)
        }, error: { (error) in
            print(error)
        }) { (failure) in
            print(failure)
        }
    }
    
    
}
