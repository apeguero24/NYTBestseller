//
//  Category.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import Foundation

class Category {
    var listName: String
    var encodedName: String
    
    init(listName: String, encodedName: String) {
        self.listName = listName
        self.encodedName = encodedName
    }
}
