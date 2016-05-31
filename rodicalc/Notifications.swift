//
//  Notifications.swift
//  Календарь беременности
//
//  Created by Roman Efimov on 31.05.16.
//  Copyright © 2016 deck. All rights reserved.
//

import Foundation


func loadNotifi() {
    let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    var dateFire=NSDate()
    var fireComponents=calendar.components([NSCalendarUnit.Day , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Hour , NSCalendarUnit.Minute], fromDate:dateFire)
    let localNotification = UILocalNotification()
    for (var i = 0 ; i < 10 ; i += 1){
        for (var j = 0 ; j < 10 ; j += 1){
            if (fireComponents.hour < 12 && i == 0){
                let localNotification = UILocalNotification()
                localNotification.fireDate = NSDate(timeIntervalSinceNow: 60) // время получения уведомления
            }
            else {
                fireComponents.hour = 12
                fireComponents.minute = j
                dateFire = calendar.dateFromComponents(fireComponents)!
                let localNotification = UILocalNotification()
                localNotification.fireDate = dateFire // время получения уведомления
            }
            localNotification.alertBody = "текст"
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
        fireComponents.day += 1
    }
}

func cancelLocalNotification(uniqueId: String){
    
    var notifyCancel = UILocalNotification()
    var notifyArray = UIApplication.sharedApplication().scheduledLocalNotifications
    
    for notifyCancel in notifyArray! as [UILocalNotification]{
        
        let info: [String: String] = notifyCancel.userInfo as! [String: String]
        
        if info[uniqueId] == uniqueId{
            
            UIApplication.sharedApplication().cancelLocalNotification(notifyCancel)
        }else{
            
            print("No Local Notification Found!")
        }
    }
}

func scheduleNotification(notifiDate :NSDate, notificationTitle:String, objectId:String) {
    
    var localNotification = UILocalNotification()
    localNotification.fireDate = notifiDate
    localNotification.alertBody = notificationTitle
    localNotification.timeZone = NSTimeZone.defaultTimeZone()
    localNotification.applicationIconBadgeNumber = 1
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertAction = "View"
    var infoDict = ["objectId" : objectId]
    localNotification.userInfo = infoDict
    
    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
}