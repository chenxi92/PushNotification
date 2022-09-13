//
//  URL-file.swift
//  PushNotification
//
//  Created by peak on 2022/9/13.
//

import Foundation

extension URL {
    func fileName() -> String {
        self.deletingPathExtension().lastPathComponent
    }
}
