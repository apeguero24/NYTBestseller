//
//  BestsellerListViewController.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import UIKit

class BestsellerListViewController: UIViewController {
    
    let presenter = BestsellerListPresenter()
    
    @IBOutlet weak var rankButton: UIButton!
    @IBOutlet weak var bestsellerTableView: UITableView!
    @IBOutlet weak var weekOnListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        presenter.requestBestsellerByCategory()
    }
    
    private func configureTableView() {
        bestsellerTableView.delegate = self
        bestsellerTableView.dataSource = self
    }
}

extension BestsellerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
