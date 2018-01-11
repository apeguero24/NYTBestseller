//
//  BestsellerListViewController.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import UIKit

class BestsellerListViewController: UIViewController {
    
    struct NibName {
        static let bestseller = "BestsellerTableViewCell"
    }
    
    struct CellID {
        static let bestseller = "bestsellerId"
    }
    
    let presenter = BestsellerListPresenter()
    
    @IBOutlet weak var rankButton: UIButton!
    @IBOutlet weak var bestsellerTableView: UITableView!
    @IBOutlet weak var weekOnListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        configureTableView()
        presenter.requestBestsellerByCategory()
    }
    
    private func configureTableView() {
        bestsellerTableView.delegate = self
        bestsellerTableView.dataSource = self
        
        let bestsellerNib = UINib(nibName: NibName.bestseller, bundle: nil)
        bestsellerTableView.register(bestsellerNib, forCellReuseIdentifier: CellID.bestseller)
    }
}

extension BestsellerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.bestseller, for: indexPath) as? BestsellerTableViewCell else {
            return UITableViewCell()
        }
        
        let book = presenter.books[indexPath.row]
        cell.bookTitleLabel.text = book.title
        cell.authorLabel.text = book.author
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
}

extension BestsellerListViewController: BestsellerView {
    func reloadTable() {
        bestsellerTableView.reloadData()
    }
}
