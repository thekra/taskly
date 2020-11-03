//
//  UserTask.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//

import Foundation

struct UserTask: Codable {
    let taskID: Int
    let userID, taskName, isCompleted: String
    let comment, taskDate: String?
    let  createdAt, updatedAt: String

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
