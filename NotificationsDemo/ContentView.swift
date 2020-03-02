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
    
    func showNotification() -> Void {
    
    }
    
    var body: some View {
        VStack {
            Text("Notification Demo")
            .padding(10)
            
            Button(action: { self.requestPermission() }) {
                Text("Request permission")
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Authorization"), message: Text(granted ? "Granted" : "Denied"))
            }
            .padding(10)
            
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
