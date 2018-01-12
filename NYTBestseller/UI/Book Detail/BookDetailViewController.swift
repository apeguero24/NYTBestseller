//
//  BookDetailViewController.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var amazonLinkLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let presenter = BookDetailPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let book = presenter.book {
            titleLabel.text = book.title
            amazonLinkLabel.text = book.amazonLink
            descriptionLabel.text = book.bookDescription
        }
    }

}
