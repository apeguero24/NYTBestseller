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

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.requestBookCategories()
    }
}
