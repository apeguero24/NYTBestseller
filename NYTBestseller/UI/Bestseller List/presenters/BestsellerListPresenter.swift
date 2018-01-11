//
//  BestsellerListPresenter.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol BestsellerView: class {
    func reloadTable()
    func refreshCell(index: Int)
}

class BestsellerListPresenter {
    
    var category: Category?
    var books = [Book]()
    weak var view: BestsellerView?
    
    typealias BookCoverCompletion = (String?) -> Void
    
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
    
    func fetchBookCover(forISBN isbn: String, completion: @escaping BookCoverCompletion) {
        let key = "&key=\(NYT_URL.googleApiKey)"
        guard let imageURL = URL(string: NYT_URL.coverURL + isbn + key) else {
            print("error converting string to URL")
            return
        }
        print(imageURL)
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let content = data else {
                print("2")
                completion(nil)
                return
            }
            
            let json = JSON(content)
            print(json)
            guard let item = json["items"].arrayValue.first else {
                completion(nil)
                return
            }
            
            let imageLink = item["volumeInfo"]["imageLinks"]["thumbnail"].stringValue.replace(target: "http", withString: "https")
            completion(imageLink)
        }
        
        task.resume()
    }
        
    private func parseBestsellerInCategory(results: [JSON]) {
        results.forEach { result in
            guard let bookDetails = result["book_details"].arrayValue.first else { return }
            let title = bookDetails["title"].stringValue
            let author = bookDetails["author"].stringValue
            let description = bookDetails["description"].stringValue
            let isbns = bookDetails["primary_isbn10"].stringValue
            
            let amazonLink = result["amazon_product_url"].stringValue
            let rank = result["rank"].intValue
            let category = result["list_name"].stringValue
            let weekOnList = result["weeks_on_list"].intValue
            
            let book = Book(title: title, author: author, description: description, amazonLink: amazonLink, category: category, weeksOnList: weekOnList, rank: rank, isbns: isbns)
            self.books.append(book)
        }
        
        view?.reloadTable()
        
        self.books.enumerated().forEach { (i, book) in
            fetchBookCover(forISBN: book.isbns, completion: { (imageURL) in
                guard let URLString = imageURL, let url = URL(string: URLString) else { return }
                book.coverLink = url
                DispatchQueue.main.async {
                    self.view?.refreshCell(index: i)
                }
            })
        }
    }
}
