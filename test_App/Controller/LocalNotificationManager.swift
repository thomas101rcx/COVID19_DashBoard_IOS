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
    func addNotification(title: String, dateTime : DateComponents) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title,datetime: dateTime ))
    }
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
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
