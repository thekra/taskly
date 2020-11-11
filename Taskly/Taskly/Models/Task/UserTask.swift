//
//  UserTask.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//

import Foundation
import UIKit

struct UserTask: Codable {
    let taskID: Int
    let userID, taskName, isCompleted: String
    let comment, taskDate: String?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case taskID = "id"
        case userID = "user_id"
        case taskName = "task_name"
        case comment
        case isCompleted = "is_completed"
        case taskDate = "task_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

typealias UserTasks = [UserTask]



func checkRemaining(taskDueDate: String) -> String {
    var result = ""
    
    let now = Date()
    let dueDate = formatter.date(from: taskDueDate)!
    let diffComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: dueDate)
    guard let days = diffComponents.day, let hours = diffComponents.hour, let mins = diffComponents.minute else {
        return ""
    }
    
    
    var timeRemaining: String {
        return Date().timeRemain(until: dueDate)!
    }
    print(timeRemaining)
    let statement = dueDate > now ? "Due date is in" : "Due date has passed"
//    let end = timeRemaining > formatter.string(from: now) ? "ago" : ""
    
    if days >= 1 {
        result = "\(statement) \(days) days"
    } else if days < 0 {
        result = "\(statement) \(abs(days)) days ago"
    } else if days == 0 {
        if hours >= 1 {
            result = "\(statement) \(hours) hour"
        } else if hours < 0 {
            result = "\(statement) \(abs(hours)) hours ago"
        } else if hours == 0 {
            if mins >= 1 {
                result = "\(statement) \(mins) mins"
            } else {
                result = "\(statement) \(abs(mins)) mins ago"
            }
        }
    }
    return result
}

let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    return formatter
}()
