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
    
    @IBOutlet weak var rankingView: UIView!
    @IBOutlet weak var weeksView: UIView!
    @IBOutlet weak var stackTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var weeksLabel: UILabel!
    
    var rankAscending = false
    var weeksAscending = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let height = navigationController?.navigationBar.frame.size.height {
            stackTopConstraint.constant = height
            
        }
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
        weeksLabel.textColor = .black
        weeksView.backgroundColor = .white
        weeksAscending = false
        
        if rankAscending {
            rankButton.setTitle("Highest to Lowest +", for: .normal)
            rankLabel.textColor = .white
            rankButton.setTitleColor(.white, for: .normal)
            rankingView.backgroundColor = .blue
            presenter.sortByRanking(ascending: true)
            rankAscending = false
        } else {
            rankButton.setTitle("Lowest to Highest -", for: .normal)
            rankLabel.textColor = .white
            rankButton.setTitleColor(.white, for: .normal)
            rankingView.backgroundColor = .red
            presenter.sortByRanking(ascending: false)
            rankAscending = true
        }

    }
    
    @IBAction func weeksOnListButtonPressed(_ sender: Any) {
        rankButton.setTitle("-Not Selected-", for: .normal)
        rankButton.setTitleColor(.lightGray, for: .normal)
        rankLabel.textColor = .black
        rankingView.backgroundColor = .white
        rankAscending = false
        
        if weeksAscending {
            weekOnListButton.setTitle("Most to Least +", for: .normal)
            weekOnListButton.setTitleColor(.white, for: .normal)
            weeksLabel.textColor = .white
            weeksView.backgroundColor = .blue
            presenter.sortByWeekOnList(ascending: true)
            weeksAscending = false
        } else {
            weekOnListButton.setTitle("Least to Most -", for: .normal)
            weekOnListButton.setTitleColor(.white, for: .normal)
            weeksLabel.textColor = .white
            weeksView.backgroundColor = .red
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
        cell.rankingLabel.text = "Rank #\(book.rank)"
        cell.weeksOnListLabel.text = "Weeks on List: \(book.weeksOnList)"
        configureCoverImage(forBook: book, withCell: cell)
        
        return cell
    }
    
    func configureCoverImage(forBook book: Book, withCell cell: BestsellerTableViewCell) {
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        cell.coverImageView.kf.setImage(with: book.coverLink, placeholder: nil, options: nil, progressBlock: nil) { (image, error, _, _) in
            if image != nil {
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.isHidden = true
                }
            } else {
                print("nil image")
            }
        }
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
        bestsellerTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
