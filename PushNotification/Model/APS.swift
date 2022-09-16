//
//  APS.swift
//  PushNotification
//
//  Created by peak on 2022/9/16.
//

import Foundation

struct APS: Encodable {
    struct Alert: Encodable {
        var title: String = ""
        var subtitle: String = ""
        var body: String = ""
    }
    var alert: Alert
    
    var badge: Int = 0
    
    init() {
        alert = .init()
    }
}

extension APS {
    var isEmpty: Bool {
        if !alert.title.isEmpty || !alert.subtitle.isEmpty || !alert.body.isEmpty {
            return false
        }
        return true
    }
}

