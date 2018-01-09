//
//  BestsellerListPresenter.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import Foundation
import SwiftyJSON

class BestsellerListPresenter {
    
    func requestBestsellerByCategory() {
        let category = "hardcover-fiction"
        NYTNetwork.default.request(target: .list(category: category), success: { (data) in
            let json = JSON(data as Any)
            print(json["results"].arrayValue)
        }, error: { (error) in
            print(error)
        }) { (failure) in
            print(failure)
        }
    }
}
