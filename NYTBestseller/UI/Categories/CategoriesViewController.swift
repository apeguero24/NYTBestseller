//
//  CategoriesViewController.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    struct NibName {
        static let category = "CategoryTableViewCell"
    }
    
    struct CellID {
        static let category = "categoriesId"
    }
    
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
        
        let categoryNib = UINib(nibName: NibName.category, bundle: nil)
        categoriesTableView.register(categoryNib, forCellReuseIdentifier: CellID.category)
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.category, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .lightGray
        } else {
            cell.backgroundColor = .white
        }
        
        cell.categoryLabel.text = presenter.categories[indexPath.row].listName
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selecting")
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
