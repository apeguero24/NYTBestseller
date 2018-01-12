//
//  Category.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import Foundation

class Category: NSObject, NSCoding {
    var listName: String
    var encodedName: String
    
    struct PropertyNames {
        static let listName = "listName"
        static let encodedName = "encodedName"
    }
    
    init(listName: String, encodedName: String) {
        self.listName = listName
        self.encodedName = encodedName
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.listName, forKey: PropertyNames.listName)
        aCoder.encode(self.encodedName, forKey: PropertyNames.encodedName)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        let listName = aDecoder.decodeObject(forKey: PropertyNames.listName) as? String ?? ""
        let encodedName = aDecoder.decodeObject(forKey: PropertyNames.encodedName) as? String ?? ""
        self.init(listName: listName, encodedName: encodedName)
    }


}
