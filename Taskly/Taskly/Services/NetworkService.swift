//
//  NetworkService.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 14/03/1442 AH.
//

import Foundation

class NetworkService {
    
    func request<T: Decodable>(endpoint: EndPoint, success: @escaping (T) -> Void) {
        var request = URLRequest(url: URL(string: endpoint.path)!)
        request.allHTTPHeaderFields = endpoint.headers
        request.httpMethod = endpoint.method.rawValue
        URLSession.shared.dataTask(with: request) { (data ,response ,error) in
            guard error == nil else { return }
            guard let response = response as? HTTPURLResponse else { return }
            guard Array(200...299).contains(response.statusCode) else { return }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode(T.self, from: data)
                success(object)
            } catch {
                print(error)
            }
        }.resume()
    }
}
