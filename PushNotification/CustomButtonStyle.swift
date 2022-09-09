//
//  CustomButtonStyle.swift
//  PushNotification
//
//  Created by peak on 2022/9/9.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnable: Bool
            
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title.bold())
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(
                isEnable ? Color.indigo : Color.gray.opacity(0.8)
            )
            .clipShape(Capsule())
            .shadow(
                color: .black.opacity(0.5),
                radius: 3,
                x: 3,
                y: 3
            )
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .animation(
                .easeOut(duration: 0.2),
                value: configuration.isPressed
            )
    }
}
