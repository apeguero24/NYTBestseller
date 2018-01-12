//
//  BestsellerListPresenter.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import Foundation
import SwiftyJSON

// Allows this presenter to communicate with BestsellerListViewController
protocol BestsellerView: class {
    func reloadTable()
    func booksDidLoad()
    func refreshCell(index: Int)
}

class BestsellerListPresenter {
    
    var category: Category?
    var books = [Book]()
    weak var view: BestsellerView? //a generic format for communicating with view controller
    
    typealias BookCoverCompletion = (String?) -> Void
    
    /**
        This method will request the bestsellers from the API and convert it to a SwiftyJSON format. Additionally, it called attempts to parse.
     - returns: Void
     */
    func requestBestsellerByCategory() {
        retrieveStoredBooks()
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
    
    /**
        This method will store the desired user options based on an optional boolean toggle, it's stored in UserDefaults with a uniqueKey formed from the chosen setting name and the encoded category name.
     - parameter setting: Optional boolean from selected setting (ranking or weeks)
     - parameter key: Actual setting name (ranking or weeks)
     - returns: Void
     */
    func storeSettings(setting: Bool?, key: String) {
        guard let category = self.category else { return }
        let uniqueKey = "\(key)-\(category.encodedName)"
        UserDefaults.standard.set(setting, forKey: uniqueKey)
    }
    
    /**
     This method will retrieve the desired user options based on an optional boolean toggle, it retrieves from UserDefaults with a uniqueKey formed from the chosen setting name and the encoded category name.
     - parameter key: Actual setting name (ranking or weeks)
     - returns: An optional boolean value, nil if not found
     */
    func retrieveSettings(key: String) -> Bool? {
        guard let category = self.category else { return false }
        let uniqueKey = "\(key)-\(category.encodedName)"
        return UserDefaults.standard.object(forKey: uniqueKey) as? Bool
    }
    
    /**
        This method retrived the stored books from UserDefaults, useful for when there's no connection.
     - returns: Void
     */
    private func retrieveStoredBooks() {
        guard let category = self.category else { return }
        if let data = UserDefaults.standard.object(forKey: category.encodedName) as? Data,
            let books = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Book] {
            self.books = books
            
        } else {

        }
        view?.booksDidLoad()
        view?.reloadTable()
    }
    
    /**
        This method will store the recently downloaded books to UserDefaults, thus updating old book data
     - returns: Void
     */
    private func storeBooks() {
        guard let category = self.category else { return }
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: books)
        UserDefaults.standard.removeObject(forKey: category.encodedName)
        UserDefaults.standard.set(encodedData, forKey: category.encodedName)
    }
    
    /**
        Sorts based on the ranking.
     - parameter ascending: A boolean that will determine if to sort in ascending or descending order
     - returns: Void
     */
    func sortByRanking(ascending: Bool) {
        if ascending {
            books.sort { $0.rank < $1.rank }
        } else {
            books.sort { $0.rank > $1.rank }
        }
        view?.reloadTable()
    }
    
    /**
     Sorts based on the number of weeks on bestseller list.
     - parameter ascending: A boolean that will determine if to sort in ascending or descending order
     - returns: Void
     */
    func sortByWeekOnList(ascending: Bool) {
        if ascending {
            books.sort { $0.weeksOnList > $1.weeksOnList }
        } else {
            books.sort { $0.weeksOnList < $1.weeksOnList }
        }
        view?.reloadTable()
    }
    
    /**
        This method fetches and parses the covers for books from the Google API, it does so asynchronously.
     - parameter isbn: The ISBN number for the book
     - completion: callback that passes the cover image link or nil
     - returns: Void
     */
    private func fetchBookCover(forISBN isbn: String, completion: @escaping BookCoverCompletion) {
        let key = "&key=\(NYT_URL.googleApiKey)"
        guard let imageURL = URL(string: NYT_URL.coverURL + isbn + key) else {
            print("error converting string to URL")
            return
        }

        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let content = data else {
                completion(nil)
                return
            }
            
            let json = JSON(content)
            guard let item = json["items"].arrayValue.first else {
                completion(nil)
                return
            }
            
            let imageLink = item["volumeInfo"]["imageLinks"]["thumbnail"].stringValue.replace(target: "http", withString: "https")
            completion(imageLink)
        }
        
        task.resume()
    }
    
    /**
        This method parses the bestsellers and requests their respective covers.
     - parameter results: An array of JSON objects containing books
     - returns: Void
     */
        
    private func parseBestsellerInCategory(results: [JSON]) {
        books.removeAll()
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
            
            let book = Book(title: title, author: author, bookDescription: description, amazonLink: amazonLink, category: category, weeksOnList: weekOnList, rank: rank, isbns: isbns)
            self.books.append(book)
        }

        view?.booksDidLoad()
        storeBooks() // storing books to keep the persitance layer fresh
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
