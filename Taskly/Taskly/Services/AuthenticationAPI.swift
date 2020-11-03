//
//  AuthenticationAPI.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//

import Foundation

class AthuenticationAPI {
    
    class func login(email:String, password: String, completion: @escaping (LoginResponse, _ succuss: Bool) -> Void) {
        let url = URL(string: URLs.login)
        guard let requestUrl = url else { return } // { fetalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let body           = Loginn(email: email, password: password)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            guard let data = data else { return }
            
            do {
                let responseObject = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(responseObject, true)
                let token = responseObject.accessToken
                let name = responseObject.userData.name
                UserDefaults.standard.setValue(token, forKey: "token")
                UserDefaults.standard.setValue(name, forKey: "name")
            } catch {
                print(error)
                if response.statusCode == 401 {
                    print("الايميل/الكلمة السرية غير صحيحة")
                    print("incorrect email/password")
                } else if response.statusCode == 422 {
                    print("مدخل غير صالح/مدخل مفقود")
                    print("Missing/invalid input")
                } else if response.statusCode == 500 {
                    print("خطأ في السيرفر")
                    print("Server Error")
                }
            }
        }
        task.resume()
    }
}
