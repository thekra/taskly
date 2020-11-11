//
//  Notifications.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 19/03/1442 AH.
//

import Foundation
import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            (granted, error) in
            if granted {
                print("yay")
            } else {
                print("oh!")
            }
        }
    }
    
    func scheduleNotification(dueDate: Date, taskTitle: String) {

        print("scheduleNotification")
        let center = UNUserNotificationCenter.current()
        
        UIApplication.shared.applicationIconBadgeNumber += 1
        let content = UNMutableNotificationContent()
        content.title = "A Lovely Reminder \(taskTitle)"
        content.body = "Don't forget your tasks for today"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData" : "fizzbuzz"]
        content.sound = .default
        content.badge = UIApplication.shared.applicationIconBadgeNumber as NSNumber
//        content.badge = 1

        
        var dateComponent = DateComponents()
        dateComponent.hour = Calendar.current.component(.hour, from: dueDate.addingTimeInterval(-3600))
        dateComponent.minute = Calendar.current.component(.minute, from: dueDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        print(trigger)
        center.add(request)
    }
}
