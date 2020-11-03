//
//  TaskAPI.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//

import Foundation

class TaskAPI {
    
    
    class func listTasks(completion: @escaping (UserTasks, _ succuss: Bool) -> Void) {
        
        #warning("guard or if let")
        let token: String = UserDefaults.standard.string(forKey: "token")!
        
        let url = URL(string: URLs.listTasks)
        guard let requestUrl = url else { return } // { fetalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            guard let data = data else { return }
            do {
                let responseObject = try JSONDecoder().decode(UserTasks.self, from: data)
                
                completion(responseObject, true)
                
            } catch {
                print(error)
                if response.statusCode == 400 {
                    print("bad request")
                }
                //                print(String(data: data, encoding: .utf8)!)
            }
        }
        task.resume()
    }
    
    class func createTask(taskTitle: String, taskDate: String, comment: String, completion: @escaping ( _ succuss: Bool) -> Void) {
        let token: String = UserDefaults.standard.string(forKey: "token")!
        
        let url = URL(string: URLs.createTask)
        guard let requestUrl = url else { return } // { fetalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let body           = NewTicket(task_name: taskTitle, task_date: taskDate, comment: comment)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            
            //            guard let data = data else { return }
            //            do {
            //                let responseObject = try JSONDecoder().decode(NewTaskResponse.self, from: data)
            //              DispatchQueue.main.async {
            //                completion(true)
            //            }
            //            } catch {
            //                print(error)
            //            }
            //            if response.statusCode == 422 {
            //                print("some input is invalid")
            //            }
            
            do {
                guard let data = data else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                print("json:", json)
                if response.statusCode == 422 {
                    print("some input is invalid")
                }
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print("error:", error)
            }
        }
        task.resume()
    }
    
    class func updateTask(taskID: Int, taskTitle: String, taskDate: String, comment: String, completion: @escaping ( _ succuss: Bool) -> Void) {
        
        let url = URL(string: URLs.updateTask)
        guard let requestUrl = url else { return } // { fetalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let body           = Task(taskName: taskTitle, comment: comment, taskDate: taskDate, taskID: taskID)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            
            do {
                guard let data = data else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                print("json:", json)
                if response.statusCode == 422 {
                    print("some input is invalid")
                }
                if response.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(true)
                }
                }
            } catch {
                print("error:", error)
            }
        }
        task.resume()
    }
    
    class func deleteTask(taskID: Int, completion: @escaping ( _ succuss: Bool) -> Void) {
        
        let url = URL(string: URLs.deleteTask)
        guard let requestUrl = url else { return } // { fetalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let body           = TaskID(taskID: taskID)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            
            do {
                guard let data = data else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                print("json:", json)
                if response.statusCode == 422 {
                    print("some input is invalid")
                }
                if response.statusCode == 200 {
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
            } catch {
                print("error:", error)
            }
        }
        task.resume()
    }
    
    class func isComplete(taskID: Int, isCompleted: Bool, completion: @escaping ( _ succuss: Bool) -> Void) {
        
        let url = URL(string: URLs.tickTask)
        guard let requestUrl = url else { return } // { fetalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let body           = Complete(taskID: taskID, isCompleted: isCompleted)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            
            do {
                guard let data = data else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                print("json:", json)
                if response.statusCode == 422 {
                    print("some input is invalid")
                }
                if response.statusCode == 200 {
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
            } catch {
                print("error:", error)
            }
        }
        task.resume()
    }
}
