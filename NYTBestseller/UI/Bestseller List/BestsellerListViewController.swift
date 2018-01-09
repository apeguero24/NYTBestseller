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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.requestBestsellerByCategory()
    }
}
