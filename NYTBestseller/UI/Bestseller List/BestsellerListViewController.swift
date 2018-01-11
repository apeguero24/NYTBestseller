//
//  BestsellerListViewController.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import UIKit
import Kingfisher

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
    
    var rankAscending = false
    var weeksAscending = false
    
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
    
    @IBAction func rankButtonPressed(_ sender: Any) {
        weekOnListButton.setTitle("-Not Selected-", for: .normal)
        weekOnListButton.setTitleColor(.lightGray, for: .normal)
        weeksAscending = false
        
        if rankAscending {
            rankButton.setTitle("Highest to Lowest +", for: .normal)
            rankButton.setTitleColor(.blue, for: .normal)
            presenter.sortByRanking(ascending: true)
            rankAscending = false
        } else {
            rankButton.setTitle("Lowest to Highest -", for: .normal)
            rankButton.setTitleColor(.red, for: .normal)
            presenter.sortByRanking(ascending: false)
            rankAscending = true
        }

    }
    
    @IBAction func weeksOnListButtonPressed(_ sender: Any) {
        rankButton.setTitle("-Not Selected-", for: .normal)
        rankButton.setTitleColor(.lightGray, for: .normal)
        rankAscending = false
        
        if weeksAscending {
            weekOnListButton.setTitle("Most to Least +", for: .normal)
            weekOnListButton.setTitleColor(.blue, for: .normal)
            presenter.sortByWeekOnList(ascending: true)
            weeksAscending = false
        } else {
            weekOnListButton.setTitle("Least to Most -", for: .normal)
            weekOnListButton.setTitleColor(.red, for: .normal)
            presenter.sortByWeekOnList(ascending: false)
            weeksAscending = true
        }
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
        cell.coverImageView.kf.setImage(with: book.coverLink)
        cell.rankingLabel.text = "Rank #\(book.rank)"
        cell.weeksOnListLabel.text = "Weeks on List: \(book.weeksOnList)"
        cell.activityIndicator.startAnimating()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension BestsellerListViewController: BestsellerView {
    func reloadTable() {
        bestsellerTableView.reloadData()
    }
    
    func refreshCell(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = bestsellerTableView.dequeueReusableCell(withIdentifier: CellID.bestseller, for: indexPath) as? BestsellerTableViewCell else {
            return
        }
        cell.activityIndicator.stopAnimating()
        bestsellerTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
