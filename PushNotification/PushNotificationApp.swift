//
//  PushNotificationApp.swift
//  PushNotification
//
//  Created by peak on 2022/9/9.
//

import SwiftUI

@main
struct PushNotificationApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button {
                    appDelegate.showAboutView()
                } label: {
                    Text("About \(Bundle.main.appName)")
                }
            }
        }
    }
}
