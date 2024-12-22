//
//  HamburgerMenu.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/28.
//

import SwiftUI

struct HamburgerMenu: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var vc: ContentViewController
    
    @State var newslList = newsListStatic
    @State var showAlert = false
    
    var body: some View {
        HStack {
            VStack(alignment: .center, spacing: Size.h(32)) {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            vc.showSideMenu = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(light22Font)
                            .foregroundColor(.gray800)
                            .padding(.vertical, 10)
                            .contentShape(Rectangle())
                    }
                }
                .padding(.horizontal, Size.w(18))
                .frame(height: Size.w(46))
                
                VStack(alignment: .center, spacing: Size.h(32)) {
                    SideMenuTopView()
                        .clipShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                vc.navigation = "account"
                            }
                        }
                        .padding(.bottom, Size.w(15))
                    Divider()
                    Group {
                        Button(action: {
                            withAnimation {
                                vc.navigation = "news"
                            }
                        }) {
                            NavigationLink(tag: "news", selection: $vc.navigation, destination: {
                                SideNavWrapper(title: "NOTICES") {
                                    NewsView(newsList: $newslList)
                                }}) { EmptyView() }
                            HStack(alignment: .top, spacing: 3) {
                                Text("NOTICE")
                                
                                let numberOfUnreadNotifications = newslList.filter{ !$0.isOpened }.count
                                if numberOfUnreadNotifications > 0 {
                                    Color.green400
                                        .frame(width: Size.w(5), height: Size.w(5))
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .opacity(0.3)
                        .disabled(true)
                        
                        Button(action: {
                            withAnimation {
                                vc.navigation = "account"
                            }
                        }) {
                            NavigationLink(tag: "account", selection: $vc.navigation, destination: { AccountView() }) {
                                Text("SIDE.MY_ACC")
                            }.isDetailLink(false)
                        }
                        
                        Button(action: { vc.navigation = "settings" }) {
                            NavigationLink(tag: "settings", selection: $vc.navigation, destination: { SideSettingsView() }) {
                                Text("SETTINGS")
                            }.isDetailLink(false)
                        }
                        
                        Button(action: { vc.navigation = "guide" }) {
                            NavigationLink(tag: "guide", selection: $vc.navigation, destination: {
                                NavigationWrapper(title: "ABOUT") {
                                    WebView(url: URL(string: "https://www.wethm.com/about")!)
                                }
                            }) {
                                Text("ABOUT")
                            }.isDetailLink(false)
                        }
                    }
                    .font(regular16Font)
                    .foregroundColor(.gray500)
                    //                     .padding(.horizontal, Size.h(30))
                    
                    Divider()
                    
                    Button(action: {
                        showAlert = true
                    }) {
                        if sessionManager.isLoading {
                            ProgressView()
                        } else {
                            VStack {
                                Text("LOGOUT")
                                    .font(medium14Font)
                                    .foregroundColor(.gray300)
                                    .padding(.vertical, Size.w(10))
                                    .padding(.horizontal, Size.w(23))
                            }
                            .background(Color.gray10)
                            .cornerRadius(100)
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("ALERT.LOGOUT".localized()),
                              message: Text(""),
                              primaryButton: .cancel(Text("CANCEL".localized())),
                              secondaryButton: .default(Text("YES".localized()), action: { signOut() } ))
                    }
                }
                .padding(.horizontal, Size.w(22))
                
                Spacer()
                Button(action: { vc.navigation = "admin" }) {
                    NavigationLink(tag: "admin", selection: $vc.navigation, destination: { AdminPanel() }) {
                        VStack(spacing: Size.h(4)) {
                            Text("Version \(Defaults.version) build \(Defaults.build)")
                            Text("Copyright © \(Date().toString(dateFormat: "YYYY")) Mellowing Factory")
                        }.foregroundColor(.gray300)
                            .font(regular12Font)
                    }.isDetailLink(false)
                }
                .disabled(!(userManager.apiNodeUser.email?.contains("mellowingfactory.com") ?? false || userManager.apiNodeUser.email?.contains("melab.snu.ac.kr") ?? false || userManager.apiNodeUser.email?.contains("inbox.ru") ?? false))
             
            }
            .frame(width: Size.w(300), alignment: .leading)
            .environment(\.locale, .init(identifier: languageList[Defaults.appLanguage].loc))
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .padding(.bottom, Size.w(20))
            
            Spacer()
        }.background(Color.white.ignoresSafeArea())
    }
    
    private func signOut() {
        sessionManager.signOut()
    }
}

struct HamburgerMenu_Previews: PreviewProvider {
    static let sessionManager = SessionManager()
    static let deviceManager = DeviceManager(username: "Ellie")
    static let userManager = UserManager(username: "Ellie", userId: "1")
    static let vc = ContentViewController()
    static let msc = MainScreenController()
    
    static var previews: some View {
        HamburgerMenu()
            .environmentObject(sessionManager)
            .environmentObject(deviceManager)
            .environmentObject(userManager)
            .environmentObject(vc)
            .environmentObject(msc)
    }
}

struct SideNavWrapper<Content: View>: View {
    let title: LocalizedStringKey
    @EnvironmentObject var vc: ContentViewController
    @ViewBuilder var content: Content
    
    var body: some View {
        content
            .navigationView(back: back, title: title)
    }
    
    private func back() {
        vc.navigation = nil
    }
}
