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
    
    var category: Category?
    var books = [Book]()
    
    func requestBestsellerByCategory() {
        guard let encodedName = category?.encodedName else { return }
        NYTNetwork.default.request(target: .list(category: encodedName), success: { (data) in
            let json = JSON(data as Any)
            let results = json["results"].arrayValue
            self.parseBestsellerInCategory(results: results)
        }, error: { (error) in
            print(error)
        }) { (failure) in
            print(failure)
        }
    }
    
    private func parseBestsellerInCategory(results: [JSON]) {
        results.forEach { result in
            guard let bookDetails = result["book_details"].arrayValue.first else { return }
            let title = bookDetails["title"].stringValue
            let author = bookDetails["author"].stringValue
            let description = bookDetails["description"].stringValue
            let isbns = bookDetails["primary_isbn13"].stringValue
            
            let amazonLink = result["amazon_product_url"].stringValue
            let rank = result["rank"].intValue
            let category = result["list_name"].stringValue
            let weekOnList = result["weeks_on_list"].intValue
            
            let book = Book(title: title, author: author, description: description, amazonLink: amazonLink, category: category, weeksOnList: weekOnList, rank: rank, isbns: isbns)
            self.books.append(book)
        }
    }
}
