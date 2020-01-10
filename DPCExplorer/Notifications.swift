//
//  Notifications.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 1/10/20.
//  Copyright © 2020 Nicholas Robison. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    
    func notificationRequest() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]

        notificationCenter.requestAuthorization(options: options) { didAllow, error in
            if !didAllow {
                debugPrint("User did not allow notifications")
            }

        }
    }
    
    func sendNotification(notificationType: String, msg: String) {
        let content = UNMutableNotificationContent()
        content.title = notificationType
        content.body = msg
        content.badge = 1
        
        let identifier = "Local Notification"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Delegate methods
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }
        completionHandler()
    }
}
