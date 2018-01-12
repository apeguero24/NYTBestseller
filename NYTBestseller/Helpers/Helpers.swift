//
//  Helpers.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/12/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import Foundation
import UIKit

class Helpers {
    //List of singletons
    static let alertHelper = Alert()
    
    struct Alert {
        func alert(title: String, message: String, forView view: UIViewController) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            view.present(alert, animated: true, completion: nil)
        }
    }
}
