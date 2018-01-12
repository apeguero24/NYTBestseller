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
        configureNavigationBar()
        configureTableView()
        presenter.view = self
        presenter.requestBookCategories()
    }
    
    private func configureNavigationBar() {
        title = "Categories"
    }
    
    private func configureTableView() {
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        
        let categoryNib = UINib(nibName: NibName.category, bundle: nil)
        categoriesTableView.register(categoryNib, forCellReuseIdentifier: CellID.category)
    }
    
    fileprivate func navigateToBestsellerList(withCategory category: Category) {
        let storyboard = UIStoryboard(name: StoryboardConstants.bestsellerList, bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? BestsellerListViewController else{
            return
        }
        vc.presenter.category = category
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter.categories.count
        if count == 0 {
            tableView.separatorStyle = .none
            return 0
        }
        return count
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
        let category = presenter.categories[indexPath.row]
        navigateToBestsellerList(withCategory: category)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
}

extension CategoriesViewController: CategoriesView {
    func reloadTable() {
        categoriesTableView.reloadData()
    }
    
    func setNoNetworkNoCacheView() {
        guard let networkIssueView = Bundle.main.loadNibNamed("NoNetworkNoCacheView", owner: nil, options: nil)?.first as? NoNetworkNoCacheView else {
            return
        }
        networkIssueView.sizeToFit()
        categoriesTableView.backgroundView = networkIssueView
        categoriesTableView.separatorStyle = .none
    }
}
