//
//  ContentView.swift
//  PushNotification
//
//  Created by peak on 2022/9/9.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = PushNotificationViewModel()
    
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
        .frame(minWidth: 350, minHeight: 280)
        .alert(viewModel.alertTitle, isPresented: $viewModel.isShowAlter, actions: {
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
            TextField(text: $viewModel.pushCertificateFilePath, prompt: Text("Please select a push certificate file")) {
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
            TextField(text: $viewModel.pushPrivateKeyFilePath, prompt: Text("Please select a push private key file")) {
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
                TextField(text: $viewModel.privateKeyFilePassword, prompt: Text("Input the password for the private key file, if no password keep empty.")) {
                    Text("Password:")
                        .foregroundColor(.purple)
                }
                placeholderButton
            }
        }
    }
    
    var topicRow: some View {
        HStack {
            TextField(text: $viewModel.topic, prompt: Text("Please input the bunle id")) {
                Text("Topic:")
            }
            placeholderButton
        }
    }
    
    var deviceTokenRow: some View {
        HStack {
            TextField(text: $viewModel.deviceToken, prompt: Text("Please input the device token")) {
                Text("Device Token:")
            }
            placeholderButton
        }
    }
    
    var contentRow: some View {
        HStack {
            TextField(text: $viewModel.content, prompt: Text("Please input the notification content")) {
                Text("Content:")
            }
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
                Text("Send Notification")
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
    }
}
