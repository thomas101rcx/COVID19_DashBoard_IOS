//
//  LocalNotificationManager.swift
//  test_App
//
//  Created by Thomas Lai on 9/15/20.
//  Copyright © 2020 Thomas Lai. All rights reserved.
//  Send notification to user

import UserNotifications
import UIKit


struct Notification {
    var id: String
    var title: String
    var body : String
    var datetime : DateComponents
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    // We have permission!
                }
        }
    }
    func addNotification(title: String, body : String,dateTime : DateComponents) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title, body : body,datetime: dateTime ))
    }
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            let userActions = "User Actions"
            content.title = notification.title
            content.body = notification.body
            content.sound = .default
            content.badge = 1
            content.categoryIdentifier = userActions
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
            let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
                let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
                let category = UNNotificationCategory(identifier: userActions, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([category])
        }
    }
    func schedule() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
    func cancelNotifications() -> Void {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
