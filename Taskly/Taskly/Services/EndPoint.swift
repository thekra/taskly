//
//  EndPoint.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 14/03/1442 AH.
//

import Foundation

protocol EndPoint {
//    var baseUrl: String { get }
    var path: String { get }
    var headers: [String:String] { get }
    var parameters: [String:Any] { get }
    var method: HTTPMethod { get }
}

extension EndPoint {
    func request<T: Decodable>(success: @escaping (T) -> Void) {
        NetworkService().request(endpoint: self, success: success)
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
