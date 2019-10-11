// The MIT License (MIT)
//
// Copyright (c) 2016 Ahmed Abdul Badie
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import UIKit

/// The maximum allowed notifications to be scheduled at a time by iOS.
///- important: Do not change this value. Changing this value to be over
/// 64 will cause some notifications to be discarded by iOS.
let MAX_ALLOWED_NOTIFICATIONS = 64

///- author: Ahmed Abdul Badie
class ABNScheduler {
    
    /// The maximum number of allowed UILocalNotification to be scheduled. Four slots
    /// are reserved if you would like to schedule notifications without them being queued.
    ///> Feel free to change this value.
    ///- attention: iOS by default allows a maximum of 64 notifications to be scheduled
    /// at a time.
    ///- seealso: `MAX_ALLOWED_NOTIFICATIONS`
    static let maximumScheduledNotifications = 60
    
    /// The key of the notification's identifier.
    fileprivate let identifierKey = "ABNIdentifier"
    /// The key of the notification's identifier.
    static let identifierKey = "ABNIdentifier"
    
    ///- parameters:
    ///    - alertBody: Alert body of the notification.
    ///    - fireDate: The date in which the notification will be fired at.
    ///- returns: Notification's identifier if it was successfully scheduled, nil otherwise.
    /// To get an ABNotificaiton instance of this notification, use this identifier with 
    /// `ABNScheduler.notificationWithIdentifier(_:)`.
    class func schedule(alertBody: String, fireDate: Date) -> String? {
        let notification = ABNotification(alertBody: alertBody)
        if let identifier = notification.schedule(fireDate: fireDate) {
            return identifier
        }
        return nil
    }
    
    ///Cancels the specified notification.
    ///- paramater: Notification to cancel.
    class func cancel(_ notification: ABNotification) {
        notification.cancel()
    }
    
    ///Cancels all scheduled UILocalNotification and clears the ABNQueue.
    class func cancelAllNotifications() {
        UIApplication.shared.cancelAllLocalNotifications()
        ABNQueue.queue.clear()
        let _ = saveQueue()
        print("All notifications have been cancelled")
    }
    
    ///- returns: ABNotification of the farthest UILocalNotification (last to be fired).
    class func farthestLocalNotification() -> ABNotification? {
        if let localNotification = UIApplication.shared.scheduledLocalNotifications?.last {
            return notificationWithUILocalNotification(localNotification)
        }
        return nil
    }
    
    ///- returns: Count of scheduled UILocalNotification by iOS.
    class func scheduledCount() -> Int {
        return (UIApplication.shared.scheduledLocalNotifications?.count)!
    }
    
    ///- returns: Count of queued ABNotification.
    class func queuedCount() -> Int {
        return ABNQueue.queue.count()
    }
    
    ///- returns: Count of scheduled UILocalNotification and queued ABNotification.
    class func count() -> Int {
        return scheduledCount() + queuedCount()
    }
    
    ///Schedules the maximum possible number of ABNotification from the ABNQueue
    class func scheduleNotificationsFromQueue() {
        for _ in 0..<(min(maximumScheduledNotifications, MAX_ALLOWED_NOTIFICATIONS) - scheduledCount()) where ABNQueue.queue.count() > 0 {
            let notification = ABNQueue.queue.pop()
            let _ = notification.schedule(fireDate: notification.fireDate!)
        }
    }
    
    
    ///Creates an ABNotification from a UILocalNotification or from the ABNQueue.
    ///- parameter identifier: Identifier of the required notification.
    ///- returns: ABNotification if found, nil otherwise.
    class func notificationWithIdentifier(_ identifier: String) -> ABNotification? {
        let notifs = UIApplication.shared.scheduledLocalNotifications
        let queue = ABNQueue.queue.notificationsQueue()
        if notifs?.count == 0 && queue.count == 0 {
            return nil
        }
        
        for note in notifs! {
            let id = note.userInfo![ABNScheduler.identifierKey] as! String
            if id == identifier {
                return notificationWithUILocalNotification(note)
            }
        }
        
        if let note = ABNQueue.queue.notificationWithIdentifier(identifier) {
            return note
        }
        
        return nil
    }
    
    ///Instantiates an ABNotification from a UILocalNotification.
    ///- parameter localNotification: The UILocalNotification to instantiate an ABNotification from.
    ///- returns: The instantiated ABNotification from the UILocalNotification.
    class func notificationWithUILocalNotification(_ localNotification: UILocalNotification) -> ABNotification {
        return ABNotification.notificationWithUILocalNotification(localNotification)
    }
    
    
    ///Reschedules all notifications by copying them into a temporary array,
    ///cancelling them, and scheduling them again.
    class func rescheduleNotifications() {
        let notificationsCount = count()
        var notificationsArray = [ABNotification?](repeating: nil, count: notificationsCount)
        
        let scheduledNotifications = UIApplication.shared.scheduledLocalNotifications
        var i = 0
        for note in scheduledNotifications! {
            let notif = notificationWithIdentifier(note.userInfo?[identifierKey] as! String)
            notificationsArray[i] = notif
            notif?.cancel()
            i += 1
        }
        
        let queuedNotifications = ABNQueue.queue.notificationsQueue()
        
        for note in queuedNotifications {
            notificationsArray[i] = note
            i += 1
        }
        
        cancelAllNotifications()
        
        for note in notificationsArray {
            let _ = note?.schedule(fireDate: (note?.fireDate)!)
        }
    }
    
    ///Retrieves the total scheduled notifications (by iOS and in the notification queue) and returns them as ABNotification array.
    ///- returns: ABNotification array of scheduled notifications if any, nil otherwise.
    class func scheduledNotifications() -> [ABNotification]? {
        if let localNotifications = UIApplication.shared.scheduledLocalNotifications {
            var notifications = [ABNotification]()
            
            for localNotification in localNotifications {
                notifications.append(ABNotification.notificationWithUILocalNotification(localNotification))
            }
            
            return notifications
        }
        
        return nil
    }
    
    ///- returns: The notifications queue.
    class func notificationsQueue() -> [ABNotification] {
        return ABNQueue.queue.notificationsQueue()
    }
    
    ///Persists the notifications queue to the disk
    ///> Call this method whenever you need to save changes done to the queue and/or before terminating the app.
    class func saveQueue() -> Bool {
        return ABNQueue.queue.save()
    }
    
    //MARK: Testing
    
    /// Use this method for development and testing.
    ///> Prints all scheduled and queued notifications.
    ///> You can freely modifiy it without worrying about affecting any functionality.
    class func listScheduledNotifications() {
        let notifs = UIApplication.shared.scheduledLocalNotifications
        let notificationQueue = ABNQueue.queue.notificationsQueue()
        
        if notifs?.count == 0 && notificationQueue.count == 0 {
            print("There are no scheduled notifications")
            return
        }
        
        print("SCHEDULED")
        
        var i = 1
        for note in notifs! {
            let id = note.userInfo![identifierKey] as! String
            print("\(i) Alert body: \(note.alertBody!) - Fire date: \(note.fireDate!) - Repeats: \(ABNotification.calendarUnitToRepeats(calendarUnit: note.repeatInterval)) - Identifier: \(id)")
            i += 1
        }
        
        print("QUEUED")
        
        for note in notificationQueue {
            print("\(i) Alert body: \(note.alertBody) - Fire date: \(note.fireDate!) - Repeats: \(note.repeatInterval) - Identifier: \(note.identifier)")
            i += 1
        }
        
        print("")
    }
    
    /// Used only for testing.
    /// - important: This method is only used to test that loading the queue is successful. Do not use it in production. The `ABNQueue().load()` method is called automatically when initially accessing the notification queue.
    /// - returns: Array of notifications read from disk.
    class func loadQueue() -> [ABNotification]? {
        return ABNQueue().load()
    }
}

//MARK:- Extensions

//MARK: NSDate

extension Date {
    
    /**
     Add a number of minutes to a date.
     > This method can add and subtract minutes.
     
     - parameter minutes: The number of minutes to add.
     - returns: The date after the minutes addition.
     */
    
    func nextMinutes(_ minutes: Int) -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.minute = minutes
        return (calendar as NSCalendar).date(byAdding: components, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    /**
     Add a number of hours to a date.
     > This method can add and subtract hours.
     
     - parameter hours: The number of hours to add.
     - returns: The date after the hours addition.
     */
    
    func nextHours(_ hours: Int) -> Date {
        return self.nextMinutes(hours * 60)
    }
    
    /**
     Add a number of days to a date.
     >This method can add and subtract days.
     
     - parameter days: The number of days to add.
     - returns: The date after the days addition.
     */
    
    func nextDays(_ days: Int) -> Date {
        return nextMinutes(days * 60 * 24)
    }
    
    func removeSeconds() -> Date {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: components)!
    }
    
    /**
     Creates a date object with the given time and offset. The offset is used to align the time with the GMT.
     
     - parameter time: The required time of the form HHMM.
     - parameter offset: The offset in minutes.
     - returns: Date with the specified time and offset.
     */
    
    static func dateWithTime(_ time: Int, offset: Int) -> Date {
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: Date())
        components.minute = (time % 100) + offset % 60
        components.hour = (time / 100) + (offset / 60)
        var date = calendar.date(from: components)!
        if date < Date() {
            date = date.nextMinutes(60*24)
        }
        
        return date
    }
    
}

//MARK: Int

extension Int {
    var date: Date {
        return Date.dateWithTime(self, offset: 0)
    }
}
