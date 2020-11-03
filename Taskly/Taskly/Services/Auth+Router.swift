//
//  Auth+Router.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 14/03/1442 AH.
//

import Foundation


extension Router {
    
    enum auth: AuthAPI {
        case login(email: String, password: String)
        case register(name: String, email: String, password: String, password_confirmation: String)
        
        var parameters: [String : Any] {
            switch self {
            case .login(let email, let password):
                var params: [String : Any] = [:]
                params["email"] = email
                params["password"] = password
                return params
                
            case .register(name: let name, email: let email, password: let password, password_confirmation: let password_confirmation):
                var params: [String : Any] = [:]
                params["name"] = name
                params["email"] = email
                params["password"] = password
                params["password_confirmation"] = password_confirmation
                return params
            }
        }
        
        var method: HTTPMethod {
            .post
        }
        
        
    }
}
