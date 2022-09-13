//
//  AboutMeView.swift
//  PushNotification
//
//  Created by peak on 2022/9/13.
//

import SwiftUI

struct AboutMeView: View {
    let repositoryURL: URL = URL(string: "https://github.com/chenxi92/PushNotification")!
    
    var body: some View {
        VStack(spacing: 10) {
            Image(nsImage: NSImage(named: "AppIcon")!)
                .padding()
            
            Text("\(Bundle.main.appName)")
                .font(.title.bold())
            
            Text("Version: \(Bundle.main.appVersion) (\(Bundle.main.appBuildVersion)) ")
                .foregroundColor(.secondary)
            
            Link("Source Code", destination: repositoryURL)
            
            Text(Bundle.main.copyright)
        }
        .font(.body)
        .padding()
        .frame(minWidth: 300, maxWidth: 300)
    }
}

struct AboutMeView_Previews: PreviewProvider {
    static var previews: some View {
        AboutMeView()
    }
}
