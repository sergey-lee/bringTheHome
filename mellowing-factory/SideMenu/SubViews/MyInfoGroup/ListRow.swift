//
//  ListRow.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/27.
//

import SwiftUI

struct ListRow: View {
    let name: LocalizedStringKey
    var title: String?
    var color: Color = .gray500
    var arrowIsOn = true
    var noTitle: Bool = false
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundColor(color)
            Spacer()
            if !noTitle {
                Text((title == nil || title == "") ? "NO_SETTINGS" : LocalizedStringKey(title!))
                    .foregroundColor((title == nil || title == "") ? .gray100 : .gray400)
            }
            if arrowIsOn {
                Image("chevron-up")
                    .rotationEffect(Angle(degrees: 90))
            }
        }
        .frame(height: Size.w(32))
        .font(regular16Font)
        .padding(.horizontal, Size.w(16))
        .padding(.vertical, Size.w(14))
    }
}

struct ListRow_Previews: PreviewProvider {
    static let sessionManager = SessionManager()
    static let deviceManager = DeviceManager(username: "sergey@mellowingfactory.com")
    static let userManager = UserManager(username: "sergey@mellowingfactory.com", userId: "1")
    static let msc = MainScreenController()
    
    static var previews: some View {
        NavigationView {
            SideSettingsView()
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
