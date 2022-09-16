//
//  SettingViewModel.swift
//  PushNotification
//
//  Created by peak on 2022/9/16.
//

import SwiftUI

enum Language: String, CaseIterable, Identifiable {
    case zh_Hans = "zh-Hans"
    case en = "en"
    var id: String { self.rawValue }
}

enum LanguageString: String, CaseIterable, Identifiable {
    case zh_hans = "中文"
    case en = "English"
    var id: String { self.rawValue }
}

extension LanguageString {
    var suggestedLanguage: Language {
        switch self {
        case .zh_hans:
            return .zh_Hans
        case .en:
            return .en
        }
    }
}

class SettingViewModel: ObservableObject {
    @AppStorage("push_setting_language") var language: Language = .en
}
