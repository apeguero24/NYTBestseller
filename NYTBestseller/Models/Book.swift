//
//  Book.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import Foundation

class Book: NSObject, NSCoding {
    var title: String
    var author: String
    var bookDescription: String
    var coverLink: URL?
    var amazonLink: String
    var category: String
    var rank: Int
    var weeksOnList: Int
    var isbns: String
    
    struct PropertyNames {
        static let title = "title"
        static let author = "author"
        static let bookDescription = "bookDescription"
        static let coverLink = "coverLink"
        static let amazonLink = "amazonLink"
        static let category = "category"
        static let rank = "rank"
        static let weeksOnList = "weeksOnList"
        static let isbns = "isbns"
    }
    
    init(title: String, author: String, bookDescription: String,
                  amazonLink: String, category: String, weeksOnList: Int,
                  rank: Int, isbns: String) {
        
        self.title = title
        self.author = author
        self.bookDescription = bookDescription
        self.amazonLink = amazonLink
        self.category = category
        self.rank = rank
        self.weeksOnList = weeksOnList
        self.isbns = isbns
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: PropertyNames.title)
        aCoder.encode(self.author, forKey: PropertyNames.author)
        aCoder.encode(self.bookDescription, forKey: PropertyNames.bookDescription)
        aCoder.encode(self.amazonLink, forKey: PropertyNames.amazonLink)
        aCoder.encode(self.category, forKey: PropertyNames.category)
        aCoder.encode(self.rank, forKey: PropertyNames.rank)
        aCoder.encode(self.weeksOnList, forKey: PropertyNames.weeksOnList)
        aCoder.encode(self.isbns, forKey: PropertyNames.isbns)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: PropertyNames.title) as? String ?? ""
        let author = aDecoder.decodeObject(forKey: PropertyNames.author) as? String ?? ""
        let bookDescription = aDecoder.decodeObject(forKey: PropertyNames.bookDescription) as? String ?? ""
        let amazonLink = aDecoder.decodeObject(forKey: PropertyNames.amazonLink) as? String ?? ""
        let category = aDecoder.decodeObject(forKey: PropertyNames.category) as? String ?? ""
        
        let rank =  aDecoder.decodeInteger(forKey: PropertyNames.rank)
        let weeksOnList = aDecoder.decodeInteger(forKey: PropertyNames.weeksOnList)
        
        let isbns = aDecoder.decodeObject(forKey: PropertyNames.isbns) as? String ?? ""
        
        self.init(title: title, author: author, bookDescription: bookDescription,
                  amazonLink: amazonLink,
                  category: category, weeksOnList: weeksOnList,
                  rank: rank, isbns: isbns)
    }
}
