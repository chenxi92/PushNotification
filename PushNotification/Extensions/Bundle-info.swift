//
//  Bundle-info.swift
//  PushNotification
//
//  Created by peak on 2022/9/13.
//

import Foundation

extension Bundle {
    public var appName: String {
        getInfo("CFBundleName")
    }
    
    public var appBuildVersion: String {
        getInfo("CFBundleVersion")
    }
    public var appVersion: String {
        getInfo("CFBundleShortVersionString")
    }
    
    fileprivate func getInfo(_ key: String) -> String {
        infoDictionary?[key] as? String ?? ""
    }
}
