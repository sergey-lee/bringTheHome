//
//  SideSettingsList.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/01.
//

import SwiftUI

struct SideSettingsView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var vc: ContentViewController
    
    @State var setNavi: String?
    @State var newsList = newsListStatic
    
    @State var sleepReport = true
    @State var mainStatus = true
    @State var notice = true
    @State var marketing = true
    
    @State var notificationsIsOn = true
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ListHeaderView(title: "DEVICE_SETTINGS")
                
                VStack(spacing: 0) {
                    NavigationLink(destination: { DeviceInformation() }) {
                        ListRow(name: "DEVICE_INFORMATION", noTitle: true)
                    }
                    .isDetailLink(false)
                    .padding(.top, Size.w(2))
                    .disabled(deviceManager.connectedDevice == nil)
                    .opacity(deviceManager.connectedDevice == nil ? 0.5 : 1)
                    
                    Divider()
                    
                    NavigationLink(destination: { GuideMenuView() }) {
                        ListRow(name: "HOW_TO_USE", noTitle: true)
                    }
                    .isDetailLink(false)
                    .padding(.bottom, Size.w(2))
                }
                .tableStyle()
                
                ListHeaderView(title: "NOTIFICATIONS_SETTINGS")
                
                VStack(spacing: 0) {
                    HStack {
                        Text("ALLOW_NOTIFICATIONS")
                            .foregroundColor(.gray500)
                            .font(regular16Font)
                        Spacer()
                        ToggleView(isOn: $notificationsIsOn, width: 56) {}
                            .frame(width: Size.w(56), height: Size.w(32))
                            .onAppear() {
                                notificationsIsOn = sleepReport || mainStatus || notice || marketing
                            }
                            .onChange(of: notificationsIsOn) {bool in
                                sleepReport = bool
                                mainStatus = bool
                                notice = bool
                                marketing = bool
                            }
                    }
                    .frame(height: Size.w(32))
                    .padding(.horizontal, Size.w(16))
                    .padding(.vertical, Size.w(14))
                    .padding(.top, Size.w(2))
                    
                    Divider()
                    
                    NavigationLink(destination: {
                        NotificationsControl(sleepReport: $sleepReport, mainStatus: $mainStatus, notice: $notice, marketing: $marketing)
                    }) {
                        ListRow(name: "NOTIFICATIONS", noTitle: true)
                    }
                    .isDetailLink(false)
                    .padding(.bottom, Size.w(2))
                }
                .tableStyle()
                
                Text("SIDE.SET.HINT")
                    .font(regular14Font)
                    .foregroundColor(.gray300)
                    .padding(.top, Size.h(6))
                    .padding(.horizontal, Size.w(31))
                    .padding(.bottom, Size.h(16))
                
                ListHeaderView(title: "APPLICATION_SETTINGS")
                
                VStack(spacing: 0) {
                    NavigationLink(destination: {
                        LanguageSelection()
                    }) {
                        ListRow(name: "LANGUAGE", title: languageList[Defaults.appLanguage].lang)
                    }
                    .isDetailLink(false)
                    .padding(.top, Size.w(2))
                    
                    Divider()
                    
                    NavigationLink(destination: { UnitsSelection() }) {
                        ListRow(name: "UNIT", noTitle: true)
                    }
                    .isDetailLink(false)
                    .padding(.bottom, Size.w(2))
                }
                .tableStyle()
                
                VStack(spacing: 0) {
                    NavigationLink(destination: {
                        NavigationWrapper(title: "NOTICES") {
                            NewsView(newsList: $newsList)
                        }
                    }) {
                        ListRow(name: "NOTICE", noTitle: true)
                    }
                    .isDetailLink(false)
                    .padding(.top, Size.w(2))
                    .disabled(true)
                    .opacity(0.2)
                    
                    Divider()
                    
                    NavigationLink(destination: { ApplicationGuide() }) {
                        ListRow(name: "APPLICATION_GUIDE", noTitle: true)
                    }.isDetailLink(false)
                    
                    
                    Divider()
                    
                    ListRow(name: "VERSION", title: "v \(Defaults.version)", arrowIsOn: false)
                    
                    Divider()
                    
                    NavigationLink(destination: {
                        NavigationWrapper(title: "TERMS_AND_CONDITIONS") {
                            WebView(url: URL(string: "https://www.wethm.com/terms_of_service")!)
                            //                                TermsInfoView()
                        }}) {
                            ListRow(name: "TERMS_AND_CONDITIONS", noTitle: true)
                        }.isDetailLink(false)
                    
                    Group {
                        Divider()
                        
                        NavigationLink(destination: {
                            NavigationWrapper(title: "PRIVACY_POLICY") {
                                WebView(url: URL(string: "https://www.wethm.com/privacy_policy")!)
                                //                                    PrivacyView()
                            }}) {
                                ListRow(name: "PRIVACY_POLICY", noTitle: true)
                            }.isDetailLink(false)
                        
                        Divider()
                        
                        NavigationLink(destination: { FAQView() }) {
                            ListRow(name: "FAQ", noTitle: true)
                        }
                        .isDetailLink(false)
                        .padding(.bottom, Size.w(2))
                    }
                }
                .tableStyle()
                .padding(.bottom, Size.h(184))
            }
        }.navigationView(back: back, title: "SETTINGS", bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
    }
    
    private func back() {
        vc.navigation = nil
    }
    
    private func signOut() {
        sessionManager.signOut()
        //        sessionManager.signOut { bool in
        //            if bool {
        //                deviceManager.connectedDevice = nil
        //                userManager.apiNodeUser = ApiNodeUser()
        //            }
        //        }
    }
}

struct SideSettingsView_Previews: PreviewProvider {
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
