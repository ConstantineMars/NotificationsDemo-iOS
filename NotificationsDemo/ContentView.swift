//
//  ContentView.swift
//  NotificationsDemo
//
//  Created by Kostiantyn Mars on 3/2/20.
//  Copyright © 2020 Kostiantyn Mars. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    @State private var granted = false
    
    var body: some View {
        VStack {
            Text("Notification Demo")
            .padding(10)
            
//            Button(action: { self.requestPermission() }) {
//                Text("Request permission")
//            }
//            .alert(isPresented: $showingAlert) {
//                Alert(title: Text("Authorization"), message: Text(granted ? "Granted" : "Denied"))
//            }
//            .padding(10)
            
            Button(action: { self.showNotification() }) {
                Text("Show Notification!")
            }
            .padding(10)
        }
    }
    
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                self.granted = granted
                self.showingAlert = true
        }
    }
    
    func showNotification() {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Title"
            content.subtitle = "Subtitle"
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.second = 1
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
                print("notifications enabled")
            } else {
                print("notifications disabled")
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("can't enable notifications again - only manually")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
