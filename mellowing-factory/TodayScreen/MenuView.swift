//
//  MenuView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/05/27.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(spacing: 0) {
                if deviceManager.deviceStatus == .disconnected {
                    NavigationLink(destination: {
                            DeviceInformation()
                    }) {
                        Image("ic-exclamationmark")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.red500)
                            .frame(width: Size.w(44))
                    }
                    // MARK: Temporary disabled
                    .disabled(true)
                    .opacity(0)
                }
                /// for multiple language tests
//                Button(action: {
//                    sessionManager.appLanguage = sessionManager.appLanguage == 1 ? 0 : 1
//                    Defaults.appLanguage = sessionManager.appLanguage
//                }) {
//                    Image(systemName: "character.bubble")
//                        .font(semiBold18Font)
//                        .foregroundColor(.blue500)
//                        .frame(width: Size.w(44))
//                }
                
                Spacer()
                Button(action: {
                    withAnimation (.linear(duration: 0.3)) {
                        haptic()
                        vc.showNotifications = true
                    }
                }) {
                    let hasUnread = notificationsList.filter{!$0.isOpened && $0.date > Calendar.current.date(byAdding: .day, value: -1, to: Date())! }.count > 0
                    Image(hasUnread ? "ic-alarm-dot" : "ic-alarm")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray800)
                        .frame(width: Size.w(44))
                        .hoverEffect(.highlight)
                }
                 .disabled(true)
                 .opacity(0.2)
                
                Button(action: {
                    withAnimation (.interpolatingSpring(stiffness: 200, damping: 20)) {
                        haptic()
                        vc.showSideMenu = true
                    }
                }) {
                    Image("ic-menu")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray800)
                        .frame(width: Size.w(44))
                }
            }
            .padding(.horizontal, Size.w(5))
        }.frame(height: Size.statusBarHeight)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MenuView()
                .environmentObject(UserManager(username: "", userId: ""))
                .environmentObject(DeviceManager(username: ""))
                .environmentObject(ContentViewController())
                .environmentObject(MainScreenController())
        }
    }
}
