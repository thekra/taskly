//
//  AuthAPI.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 14/03/1442 AH.
//

import Foundation

protocol AuthAPI: EndPoint { }

extension AuthAPI {
//    var baseUrl: String {
//        URLs.main
//    }
    
    var path: String {
        URLs.login
    }
    
    var headers: [String : String] {
        var headers = [String : String]()
        headers["Accept"] = "application/json"
        return headers
    }
}
