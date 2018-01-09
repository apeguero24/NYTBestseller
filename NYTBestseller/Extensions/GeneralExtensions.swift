//
//  GeneralExtensions.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import Foundation

extension String {
    var UTF8EncodedData: Data {
        return self.data(using: String.Encoding.utf8)!
    }
}
