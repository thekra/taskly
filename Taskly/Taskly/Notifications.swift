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
    
    func scheduleNotification() {

        print("scheduleNotification")
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        UIApplication.shared.applicationIconBadgeNumber += 1
        let content = UNMutableNotificationContent()
        content.title = "a Lovely Reminder"
        content.body = "Don't forget your tasks for today"
        content.categoryIdentifier = "alarm"
//        content.userInfo = ["customData" : "fizzbuzz"]
        content.sound = .default
        content.badge = UIApplication.shared.applicationIconBadgeNumber as NSNumber
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let now = Date()
//        let fo = DateFormatter()
//        fo.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//        let dueDate = fo.date(from: dueDateString!)!
//        let diffComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: datePicker.date)
        //let days = diffComponents.day
//        let hours = diffComponents.hour
//        let mins = diffComponents.minute
//        let seconds = diffComponents.second
//        print("seconds: \(seconds)")
//        print("mins: \(String(describing: mins))")
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        if abs(mins!) > 10 {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
//        UIApplication.shared.applicationIconBadgeNumber += 1
//        }
    }
}
