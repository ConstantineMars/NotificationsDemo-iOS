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
    @State private var statusText: String = "Notification Demo"
    
    var body: some View {
        VStack {
            Text("\(statusText)")
            .padding(5)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                self.onWillEnterForeground()
            }
            
            Button(action: { self.showNotification() }) {
                Text("Show")
            }
            .padding(5)
        }
        .onAppear(perform: self.onWillEnterForeground)
    }
    
    func onWillEnterForeground()
    {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
        if settings.authorizationStatus == .authorized {
            self.statusText = "Notifications enabled"
        } else {
            self.statusText = "Notifications disabled"
        }
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

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
                print("Notifications enabled")
            } else {
                print("Notifications disabled")
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
