//
//  NotificationsControl.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/01.
//

import SwiftUI

struct NotificationsControl: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userManager: UserManager
    
    @Binding var sleepReport: Bool
    @Binding var mainStatus: Bool
    @Binding var notice: Bool
    @Binding var marketing: Bool
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Line(toggle: $sleepReport, title: "SLEEP_REPORT", description: "N.SLEEP_REPORT.DESC")
                Line(toggle: $mainStatus, title: "MAIN_STATUS", description: "N.MAIN_STATUS.DESC")
                Line(toggle: $notice, title: "NOTICE", description: "N.NOTICE.DESC")
                if let created = userManager.apiNodeUser.created {
                    Line(toggle: $marketing, title: "MARKETING_INFO", description: "N.MARKETING_INFO.DESC \(created.convertToDateString(format: "YYYY MMM dd"))")
                }
            }
            .tableStyle()
            .padding(.top, Size.h(32))
            
            Spacer()
        }
        .navigationView(back: back, title: "NOTIFICATIONS", bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
    }
    
    @ViewBuilder
    private func Line(toggle: Binding<Bool>, title: LocalizedStringKey, description: LocalizedStringKey) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .foregroundColor(.gray500)
                    .font(regular16Font)
                Spacer()
                ToggleView(isOn: toggle, width: 56) {}
                    .frame(width: Size.w(56), height: Size.w(32))
            }
            .padding(.horizontal, Size.w(20))
            .padding(.top, Size.h(20))
            .padding(.bottom, Size.h(12))
            Text(description)
                .tracking(-1)
                .foregroundColor(.gray300)
                .font(regular14Font)
                .padding(.leading, Size.w(22))
                .padding(.bottom, Size.h(14))
            Divider()
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}


struct NotificationsControl_Previews: PreviewProvider {
    static let sessionManager = SessionManager()
    static let deviceManager = DeviceManager(username: "sergey@mellowingfactory.com")
    static let userManager = UserManager(username: "sergey@mellowingfactory.com", userId: "1")
    static let msc = MainScreenController()
    
    static var previews: some View {
        NavigationView {
            NotificationsControl(sleepReport: .constant(false), mainStatus: .constant(false), notice: .constant(false), marketing: .constant(false))
                .environmentObject(sessionManager)
                .environmentObject(deviceManager)
                .environmentObject(userManager)
                .environmentObject(msc)
                .onAppear {
                    userManager.apiNodeUser = ApiNodeUser(id: "lisa", email: "lisa@gmail.com", name: "Lisa", familyName: "Wilson", membership: "basic", fakeLocation: "Dallas, TX")
                }
        }
    }
}
