//
//  GuideView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/07.
//

import SwiftUI

struct GuideMenuView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Line(title: "SETUP_GUIDE", description: "SETUP_GUIDE.HINT", destination: SetupGuideView())
                Divider()
                Line(title: "SETUP_GUIDE.LIFE", description: "SETUP_GUIDE.LIFE.HINT", destination: LifestyleGuideView())
            }
            .tableStyle()
            .padding(.top, Size.h(32))
        }
        .navigationView(back: back, title: "HOW_TO_USE", bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
    }
    
    @ViewBuilder
    private func Line(title: LocalizedStringKey, description: LocalizedStringKey, destination: some View) -> some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(title)
                        .foregroundColor(.gray500)
                        .font(regular16Font)
                    Spacer()
                    Image("chevron-up")
                        .rotationEffect(Angle(degrees: 90))
                }
                .padding(.horizontal, Size.w(20))
                .padding(.top, Size.h(22))
                .padding(.bottom, Size.h(12))
                Text(description)
                    .tracking(-1)
                    .foregroundColor(.gray300)
                    .font(regular14Font)
                    .padding(.leading, Size.w(22))
                    .padding(.bottom, Size.h(18))
            }
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct GuideMenuView_Previews: PreviewProvider {
    static let sessionManager = SessionManager()
    static let deviceManager = DeviceManager(username: "sergey@mellowingfactory.com")
    static let userManager = UserManager(username: "sergey@mellowingfactory.com", userId: "1")
    static let msc = MainScreenController()
    
    static var previews: some View {
        NavigationView {
            VStack {
                GuideMenuView()
            }
            .background(Color.gray50)
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
