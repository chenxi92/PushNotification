//
//  AlertView.swift
//  PushNotification
//
//  Created by peak on 2022/9/9.
//

import SwiftUI

struct AlertView: View {
    @EnvironmentObject var vm: PushNotificationViewModel
    
    var body: some View {
        VStack {
            Text(vm.title)
                .font(.title)
                .padding(.top)
                .foregroundColor(
                    vm.errorMessage.isEmpty ? .green : .red
                )
            
            if !vm.errorMessage.isEmpty {
                Text(vm.errorMessage)
                    .font(.body)
                    .foregroundColor(.red)
                    .padding()
            } else if !vm.successMessage.isEmpty {
                Text(vm.successMessage)
                    .font(.body)
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
        .onAppear(perform: delayReset)
    }
    
    private func delayReset() -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            vm.reset()
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    
    static var previews: some View {
        AlertView()
            .environmentObject(PushNotificationViewModel())
    }
}
