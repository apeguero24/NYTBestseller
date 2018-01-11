//
//  Book.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import Foundation

class Book {
    var title: String
    var author: String
    var description: String
    var coverLink: URL?
    var amazonLink: String
    var category: String
    var rank: Int
    var weeksOnList: Int
    var isbns: String
    
    required init(title: String, author: String, description: String,
                  amazonLink: String, category: String, weeksOnList: Int,
                  rank: Int, isbns: String) {
        
        self.title = title
        self.author = author
        self.description = description
        self.amazonLink = amazonLink
        self.category = category
        self.rank = rank
        self.weeksOnList = weeksOnList
        self.isbns = isbns
    }
}
