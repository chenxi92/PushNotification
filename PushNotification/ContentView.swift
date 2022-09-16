//
//  ContentView.swift
//  PushNotification
//
//  Created by peak on 2022/9/9.
//

import SwiftUI

struct ContentView: View {
    // Use StateObject wrapper since we don't want to re-initialize the view model.
    @StateObject var viewModel = PushNotificationViewModel()
    
    var body: some View {
        VStack {
            Form {
                certificateRow
                privateKeyRow
                privateKeyPasswordRow
                topicRow
                deviceTokenRow
                contentRow
                    .padding(.bottom)
                
                submitButtonRow
            }
        }
        .padding()
        .frame(minWidth: 350, minHeight: 370)
        .alert(Text(viewModel.alertTitle), isPresented: $viewModel.isShowAlter, actions: {
            Button {
                viewModel.reset()
            } label: {
                Text("Confirm")
            }
        }, message: {
            Text(viewModel.alertMessage)
        })
        .environmentObject(viewModel)
    }
}

// MARK: - UI
extension ContentView {
    
    var certificateRow: some View {
        HStack {
            TextField(text: $viewModel.pushCertificateFilePath, prompt: Text("Certificate placeholder")) {
                Text("Certificate:")
                    .foregroundColor(viewModel.certificateForegroundColor)
            }
            Button {
                viewModel.selectCertificateFile()
            } label: {
                Text("Select")
            }
        }
    }
    
    var privateKeyRow: some View {
        HStack {
            TextField(text: $viewModel.pushPrivateKeyFilePath, prompt: Text("Private key placeholder")) {
                Text("Private Key:")
                    .foregroundColor(viewModel.privateKeyForegroundColor)
            }
            Button {
                viewModel.selectPrivateKeyFile()
            } label: {
                Text("Select")
            }
        }
    }
    
    @ViewBuilder
    var privateKeyPasswordRow: some View {
        if viewModel.pushPrivateKeyFilePath.isEmpty == false {
            HStack {
                TextField(text: $viewModel.privateKeyFilePassword, prompt: Text("Password placeholder")) {
                    Text("Password:")
                        .foregroundColor(.purple)
                }
                placeholderButton
            }
        }
    }
    
    var topicRow: some View {
        HStack {
            TextField(text: $viewModel.topic, prompt: Text("Topic placeholder")) {
                Text("Topic:")
            }
            placeholderButton
        }
    }
    
    var deviceTokenRow: some View {
        HStack {
            TextField(text: $viewModel.deviceToken, prompt: Text("Device Token placeholder")) {
                Text("Device Token:")
            }
            placeholderButton
        }
    }
    
    var contentRow: some View {
        HStack {
            NotificationConfigurationView()
            placeholderButton
        }
    }
    
    var sandboxRow: some View {
        HStack {
            Toggle("Sandbox", isOn: $viewModel.isSandbox)
                .toggleStyle(.switch)
            
            if !viewModel.isSandbox {
                Text("⚠️ You are in production environment.")
                    .foregroundColor(.red)
                    .font(.body.bold())
            }
        }
    }
    
    var placeholderButton: some View {
        Button {} label: { Text("Select") }
            .hidden()
    }
    
    var submitButtonRow: some View {
        HStack {
            Button {
                viewModel.sendNotification()
            } label: {
                HStack {
                    if viewModel.isSending {
                        ProgressView()
                            .colorInvert()
                            .brightness(1)
                            .scaleEffect(0.75)
                            .padding(.horizontal)
                    }
            
                    Text("Send Notification")
                }
            }
            .buttonStyle(CustomButtonStyle())
            .disabled(!viewModel.isReady)
            
            placeholderButton
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, .init(identifier: "en"))
        
        ContentView()
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
