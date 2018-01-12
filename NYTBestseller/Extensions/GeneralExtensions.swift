//
//  GeneralExtensions.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import Foundation

extension String {
    
    //Computed variable that creates a UTF8 encoded Data object from a String type.
    var UTF8EncodedData: Data {
        return self.data(using: String.Encoding.utf8)!
    }
    
    /**
        Finds and replaces occurrences within a string
     - parameter target: target string to replace
     - parameter string: new string that replaces target
     - returns: Void
     */
    func replace(target: String, withString string: String) -> String {
        return self.replacingOccurrences(of: target, with: string, options: NSString.CompareOptions.literal, range: nil)
    }
}
