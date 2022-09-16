//
//  Encodable.swift
//  PushNotification
//
//  Created by peak on 2022/9/16.
//

import Foundation

extension Encodable {
    
    func toJson() -> String {
        do {
            let jsonData = try JSONEncoder().encode(self)
            if let json = String(data: jsonData, encoding: .utf8) {
                return json
            }
        } catch {
            print("convert aps to json occur error: \(error)")
            return ""
        }
        return ""
    }
}
