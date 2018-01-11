//
//  NYTNetwork.swift
//  NYTBestseller
//
//  Created by Andres Peguero on 1/9/18.
//  Copyright © 2018 Andres. All rights reserved.
//

import Foundation
import Moya

struct NYT_URL {
    static let url = "https://api.nytimes.com/svc/books/v3"
    static let apiKey = "15855bdf127b4c69b537a5e83a83cb36"
    static let coverURL = "https://www.googleapis.com/books/v1/volumes?q=isbn:"
}

class NYTNetwork {
    static var `default` =  NYTNetwork()
    
    private let provider = MoyaProvider<NYTAPI>()
    
    func request(
        target: NYTAPI,
        success successCallback: @escaping (Any?) -> Void,
        error errorCallback: @escaping (_ statusCode: Response) -> Void,
        failure failureCallback: @escaping (Moya.MoyaError) -> Void
        ) {
        
        provider.request(target, completion: { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let json = try? response.mapJSON()
                    successCallback(json)
                } catch {
                    errorCallback(response)
                }
            case let .failure(error):
                
                failureCallback(error)
            }
            
        })
    }
}

enum NYTAPI {
    case listNames
    case list(category: String)
}

extension NYTAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: NYT_URL.url)!
    }
    
    var path: String {
        switch self {
        case .listNames:
            return "/lists/names.json"
        case .list:
            return "/lists.json"
        }
    }
        
    var method: Moya.Method {
        switch self {
        case .listNames, .list:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .listNames:
            let params = ["api-key": NYT_URL.apiKey]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .list(let category):
            let params = ["api-key": NYT_URL.apiKey, "list": category]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var sampleData: Data {
        return "".UTF8EncodedData
    }
    
    var headers: [String : String]? {
        return nil
    }
}
