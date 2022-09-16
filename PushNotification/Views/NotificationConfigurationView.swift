//
//  NotificationConfigurationView.swift
//  PushNotification
//
//  Created by peak on 2022/9/16.
//

import SwiftUI

struct NotificationConfigurationView: View {
    @EnvironmentObject var vm: PushNotificationViewModel
    
    var body: some View {
        Form {
            TextField(
                "Notification Title",
                text: $vm.aps.alert.title,
                prompt: Text("Notification Title Placeholder")
            )
            TextField(
                "Notification Subtitle",
                text: $vm.aps.alert.subtitle,
                prompt: Text("Notification Subtitle Placeholder")
            )
            TextField(
                "Notification Body",
                text: $vm.aps.alert.body,
                prompt: Text("Notification Body Placeholder")
            )
            TextField(value: $vm.aps.badge, format: .number) {
                Text("Notification Badge")
            }
        }
    }
}

struct NotificationConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationConfigurationView()
            .environmentObject(PushNotificationViewModel())
            .environment(\.locale, .init(identifier: "en"))
        
        NotificationConfigurationView()
            .environmentObject(PushNotificationViewModel())
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
