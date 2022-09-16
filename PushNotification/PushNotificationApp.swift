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
    
    @StateObject var settingViewModel = SettingViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settingViewModel)
                .environment(\.locale, .init(identifier: settingViewModel.language.rawValue))
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
        
        Settings {
            SettingView()
                .environmentObject(settingViewModel)
                .environment(\.locale, .init(identifier: settingViewModel.language.rawValue))
        }
    }
}
