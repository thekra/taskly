//
//  Login.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//

import Foundation

struct Loginn: Codable {
    let email, password: String
}

extension Loginn {
    static func login(success: @escaping (Loginn) -> Void) {
//        let l = LoginViewController()
        
        Router.auth.login(email: "th-f-a-a_1@hotmail.com", password: "thekraleeshn").request(success: success)
    }
}
