//
//  PushNotificationViewModel.swift
//  PushNotification
//
//  Created by peak on 2022/9/9.
//

import SwiftUI
import UniformTypeIdentifiers

class PushNotificationViewModel: ObservableObject {
    
    @Published var pushCertificateFilePath: String = ""
    @Published var pushPrivateKeyFilePath: String = ""
    @Published var privateKeyFilePassword: String = ""
    @AppStorage("push_topic") var topic: String = ""
    @AppStorage("push_device") var deviceToken: String = ""
    @Published var content: String = ""
    @Published var isSandbox: Bool = true
    
    @Published var isShowAlter: Bool = false
    private(set) var alertTitle: String = ""
    private(set) var alertMessage: String = ""
    
    private var pemFilePath = ""
    
    var certificateForegroundColor: Color {
        if pushCertificateFilePath.isEmpty {
            return .primary
        }
        if FileManager.default.fileExists(atPath: pushCertificateFilePath) {
            return .primary
        }
        return .red
    }
    
    var privateKeyForegroundColor: Color {
        if pushPrivateKeyFilePath.isEmpty {
            return .primary
        }
        if FileManager.default.fileExists(atPath: pushPrivateKeyFilePath) {
            return .primary
        }
        return .red
    }
    
    var isReady: Bool {
        if pushCertificateFilePath.isEmpty || pushPrivateKeyFilePath.isEmpty || topic.isEmpty || deviceToken.isEmpty || content.isEmpty {
            return false
        }
        if !FileManager.default.fileExists(atPath: pushCertificateFilePath) || !FileManager.default.fileExists(atPath: pushPrivateKeyFilePath) {
            return false
        }
        return true
    }
        
    func selectCertificateFile() {
        selectSingleFile([.x509Certificate]) { selectedURL in
            self.pushCertificateFilePath = selectedURL.path
        }
    }
    
    func selectPrivateKeyFile() {
        selectSingleFile([.pkcs12]) { selectedURL in
            self.pushPrivateKeyFilePath = selectedURL.path
        }
    }
    
    func sendNotification() {
        print("\nBegin send notification ...\ncertificate = \(pushCertificateFilePath)\nprivate key = \(pushPrivateKeyFilePath)")
     
        if pemFilePath.isEmpty {
            convertP12toPem { [weak self] pemFilePath, errorMessage in
                guard let self = self else { return }
                
                if let errorMessage = errorMessage {
                    print("convert p12 file to pem occur error: \(errorMessage)")
                    self.setupAlert(title: "Convert p12 file Fail", message: errorMessage)
                    return
                }
                
                if let pemFilePath = pemFilePath {
                    self.pemFilePath = pemFilePath
                    self.sendNotification(self.content, pemFilePath)
                }
            }
        } else {
            sendNotification(content, pemFilePath)
        }
    }
    
    func reset() {
        removeFileIfNeed(self.pemFilePath)
        pemFilePath = ""
        
        isShowAlter = false
        alertTitle = ""
        alertMessage = ""
    }
    
    // MARK: - Private function
    
    private func selectSingleFile(_ fileTypes: [UTType], completion: @escaping ((URL) -> Void)) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedContentTypes = fileTypes
        if panel.runModal() == .OK, let url = panel.url {
            completion(url)
        }
    }
    
    private func sendNotification(_ content: String, _ pemFilePath: String) {
        /**
         How to generate a remote notification:
         https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/generating_a_remote_notification
         */
        
        let command = """
            curl -v \
            --header "apns-topic: \(topic)" \
            --header "apns-push-type: alert" \
            --cert "\(pushCertificateFilePath)" \
            --cert-type DER \
            --key "\(pemFilePath)" \
            --key-type PEM \
            --data '{"aps":{"alert":"\(content)"}}' \
            --http2 "https://\(APNSHostName)/3/device/\(deviceToken)"
            """
        print("execute command:\n\(command)\n")
        DispatchQueue.main.async {
            do {
                try ExecuteCommand(command: command)
                self.setupAlert(title: "Success", message: "Send Notification Success")
            } catch let error as ShellError {
                self.setupAlert(title: "Fail", message: error.message)
            } catch {
                self.setupAlert(title: "Fail", message: error.localizedDescription)
            }
        }
    }
    
    private func convertP12toPem(completion: @escaping (_ pemFilePath: String?, _ errorMessage: String?) -> Void) {
        let privateKeyFileURL = URL(fileURLWithPath: pushPrivateKeyFilePath)
        let workDirectory = privateKeyFileURL.deletingLastPathComponent().path
        let fileName = privateKeyFileURL.fileName() + "-" + String(Int.random(in: 1...1000)) + ".pem"
        let pemFilePath = workDirectory + "/" + fileName
        
        let command = "openssl pkcs12 -in '\(pushPrivateKeyFilePath)' -out '\(pemFilePath)' -nodes -passin 'pass:\(privateKeyFilePassword)'"
        
        print("execute command:\n\(command)")
        
        do {
            try ExecuteCommand(command: command)
        } catch let error as ShellError {
            removeFileIfNeed(pemFilePath)
            completion(nil, error.message)
            return
        } catch {
            removeFileIfNeed(pemFilePath)
            completion(nil, error.localizedDescription)
            return
        }
        
        assert(FileManager.default.fileExists(atPath: pemFilePath))
        
        completion(pemFilePath, nil)
    }
    
    private func removeFileIfNeed(_ file: String) {
        print("try to remove file: \(file)")
        if FileManager.default.fileExists(atPath: file) {
            try? FileManager.default.removeItem(atPath: file)
            print("remove success")
        } else {
            print("file not exist at: \(file)")
        }
    }
    
    private func setupAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.isShowAlter = true
    }
    
    private var APNSHostName: String {
        return "api.sandbox.push.apple.com"
    }
}

