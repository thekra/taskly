//
//  NewTask.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//

import Foundation

struct NewTicket: Codable {
    let task_name: String
    let task_date: String?
    let comment: String?
}

// MARK: - Task
struct Task: Codable {
    let taskName: String
    let comment: String?
    let taskDate: String?
    let taskID: Int

    enum CodingKeys: String, CodingKey {
        case taskName = "task_name"
        case comment
        case taskDate = "task_date"
        case taskID = "task_id"
    }
}

struct TaskID: Codable {
    let taskID: Int
    
    enum CodingKeys: String, CodingKey {
        case taskID = "task_id"
    }
}


struct Complete: Codable {
    let taskID: Int
    let isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case taskID = "task_id"
        case isCompleted = "is_completed"
    }
}
