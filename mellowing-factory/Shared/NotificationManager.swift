//
//  NotificationManager.swift
//  mellowing-factory
//
//  Created by Florian Topf on 21.01.22.
//

import UserNotifications

final class NotificationManager {
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in
            if let error = error {
                print("Notifications permission error: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
            
            if granted {
                print("All notifications allowed.")
            } else {
                print("All notifications disallowed.")
            }
            
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
//    var isPushNotificationEnabled = true
//    
//    func checkNotificationsPermissions() {
//        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { permission in
//            switch permission.authorizationStatus  {
//            case .authorized:
//                self.isPushNotificationEnabled = true
//                print("User granted permission for notification")
//            case .denied:
//                self.isPushNotificationEnabled = false
//                print("User denied notification permission")
//                
//            case .notDetermined:
//                self.isPushNotificationEnabled = false
//                print("Notification permission haven't been asked yet")
//                
//            case .provisional:
//                // @available(iOS 12.0, *)
//                print("The application is authorized to post non-interruptive user notifications.")
//            case .ephemeral:
//                // @available(iOS 14.0, *)
//                print("The application is temporarily authorized to post notifications. Only available to app clips.")
//            @unknown default:
//                print("Unknow Status")
//            }
//        })
//    }
}
