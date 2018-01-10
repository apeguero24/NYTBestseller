//
//  CategoriesViewController.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    let presenter = CategoriesPresenter()

    @IBOutlet weak var categoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        presenter.view = self
        presenter.requestBookCategories()
    }
    
    private func configureTableView() {
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        
        let categoryNib = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        categoriesTableView.register(categoryNib, forCellReuseIdentifier: "categoriesId")
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesId", for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.categoryLabel.text = presenter.categories[indexPath.row].listName
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
}

extension CategoriesViewController: CategoriesView {
    func reloadTable() {
        categoriesTableView.reloadData()
    }
}
