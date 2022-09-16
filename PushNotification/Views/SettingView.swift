//
//  SettingView.swift
//  PushNotification
//
//  Created by peak on 2022/9/16.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var viewModel: SettingViewModel
    
    var body: some View {
        Form {
            HStack {
                Text("Change Language")
                
                Picker("", selection: $viewModel.language) {
                    ForEach(LanguageString.allCases) { languageString in
                        Text(languageString.rawValue)
                            .tag(languageString.suggestedLanguage)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.vertical)
                .frame(idealWidth: 150)
            }
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 300, minHeight: 300)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SettingView()
                .environmentObject(SettingViewModel())
        }
    }
}
