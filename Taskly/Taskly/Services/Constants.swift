//
//  Constants.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 14/03/1442 AH.
//

import Foundation

struct URLs {
    
    static let main = "http://www.task-ly.com/api/"
    static let auth = "auth/"
    static let task = "task/"
    
    // MARK:-  AUTH
    /// POST {email, password}
    static let login    = main + auth + "login"
    
    /// POST {name, email, password, password_confirmation}
    static let register = main + auth + "register"
    
    /// GET {api_token}
    static let logout   = main + auth + "logout"
    
     
    // MARK: - Task
    
    /// POST {userID, taskName, comment, taskDate}
    static let createTask = main + task + "create"
    
    /// POST {taskName, comment, taskDate}
    static let updateTask = main + task + "update"
    
    /// GET {api_token}
    static let listTasks  = "http://www.task-ly.com/api/task/index" //main + task + "index"
    
    /// POST {task_id}
    static let deleteTask = main + task + "delete"
    
    /// POST {task_id}
    static let showTask   = main + task + "show"
    
    /// POST {task_id, is_completed}
    static let tickTask   = main + task + "isTaskCompleted"
}
