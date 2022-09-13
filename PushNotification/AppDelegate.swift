//
//  AppDelegate.swift
//  PushNotification
//
//  Created by peak on 2022/9/13.
//

import SwiftUI

/// https://stackoverflow.com/a/68922930
class AppDelegate: NSObject, NSApplicationDelegate {
    private var aboutMeWindowController: NSWindowController?
    
    public func showAboutView() {
        if aboutMeWindowController == nil {
            let window = NSWindow()
            window.styleMask = [.closable, .miniaturizable, .titled]
            window.title = "About \(Bundle.main.appName)"
            window.contentView = NSHostingView(rootView: AboutMeView())
            window.center()
            aboutMeWindowController = NSWindowController(window: window)
        }
        
        aboutMeWindowController?.showWindow(aboutMeWindowController?.window)
    }
}
