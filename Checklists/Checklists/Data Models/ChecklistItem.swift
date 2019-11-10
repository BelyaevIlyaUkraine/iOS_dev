//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Ilya Belyaev on 04/09/2019.
//  Copyright © 2019 UApps. All rights reserved.
//

import Foundation

import UserNotifications


class ChecklistItem: NSObject,Codable {
    
    var text = ""
    
    var checked = false
    
    var dueDate = Date()
    
    var shouldRemind = false
    
    var itemID = -1
    
    
    func toggleChecked() {
        checked = !checked
    }
    
    
    
    override init() {
        
         super.init()
        
         itemID = DataModel.nextChecklistItemID()
    }
    
    
    
    deinit {
        removeNotification()
    }
    
    
    
    func scheduleLocalNotification() {
        
        removeNotification()
        
        if shouldRemind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default
            
            let calendar = Calendar(identifier: .gregorian)
            
            let dateComponents = calendar.dateComponents([.year, .month, .day, .hour,  .minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            
            center.add(request)
        }
    }
    
    
    
    func removeNotification() {
        
        let center = UNUserNotificationCenter.current()
        
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
}


