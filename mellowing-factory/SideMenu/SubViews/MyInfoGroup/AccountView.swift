//
//  MyInfoList.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/29.
//

import SwiftUI
import Amplify

struct AccountView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var msc: MainScreenController
    @EnvironmentObject var vc: ContentViewController
    
    @State var showAlert = false
    @State var showDeleteAlert = false
    @State var openedFromSideMenu = false
    @State var openJoinScreen = false
    @State var showJoinAlert = false
    
    @State var success = false
    
    var body: some View {
       
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                harmonyView
                
                //            Text("MY_PROFILE")
                //                .font(medium16Font)
                //                .foregroundColor(.gray800)
                //                .frame(maxWidth: .infinity, alignment: .leading)
                //                .padding(.horizontal, Size.w(31))
                
                ListHeaderView(title: "MY_PROFILE")
                
                VStack(spacing: 0) {
                    NavigationLink(destination: { MyInfoName(name: userManager.apiNodeUser.name ?? "", familyName: userManager.apiNodeUser.familyName ?? "") }) {
                        let fullName = (userManager.apiNodeUser.familyName ?? "") + " " + (userManager.apiNodeUser.name ?? "")
                        ListRow(name: "NAME", title: fullName)
                    }
                    .isDetailLink(false)
                    .padding(.top, Size.w(2))
                    
                    Divider()
                    
                    NavigationLink(destination: { MyInfoBirth() }) {
                        ListRow(name: "BIRTH_YEAR", title: userManager.birthString)
                    }.isDetailLink(false)
                    
                    Divider()
                    
                    NavigationLink(destination: { MyInfoGender() }) {
                        ListRow(name: "GENDER", title: userManager.apiNodeUser.gender ?? "")
                    }.isDetailLink(false)
                    
                    Divider()
                    
                    NavigationLink(destination: { MyInfoWeight() }) {
                        ListRow(name: "WEIGHT", title: userManager.weightString)
                    }.isDetailLink(false)
                    
                    Divider()
                    
                    NavigationLink(destination: { MyInfoHeight() }) {
                        ListRow(name: "HEIGHT", title: userManager.heightString)
                    }
                    .isDetailLink(false)
                    .padding(.bottom, Size.w(2))
                    
                }
                .tableStyle()
                //            .frame(maxWidth: .infinity, alignment: .center)
                //            .background(Color.white)
                //            .cornerRadius(Size.w(14))
                //            .padding(.horizontal, Size.w(22))
                //            .padding(.top, Size.h(16))
                //            .padding(.bottom, Size.h(22))
                
                NavigationLink(destination: {
                    NavigationWrapper(title: "PRIVACY_POLICY") {
                        WebView(url: URL(string: "https://www.wethm.com/privacy_policy")!)
                    }
                }) {
                    HStack {
                        Text("SIDE.MY_ACC.HINT1")
                            .tracking(-0.6)
                            .foregroundColor(.gray300)
                        + Text("SIDE.MY_ACC.HINT2")
                            .underline()
                            .foregroundColor(.blue400)
                    }
                    .font(regular14Font)
                    .multilineTextAlignment(.leading)
                }
                .padding(.top, Size.h(6))
                .padding(.horizontal, Size.w(29))
                .padding(.bottom, Size.h(16))
                
                ListHeaderView(title: "ACCOUNT_SETTINGS")
                
                //            Text("ACCOUNT_SETTINGS")
                //                .font(medium16Font)
                //                .foregroundColor(.gray800)
                //                .frame(maxWidth: .infinity, alignment: .leading)
                //                .padding(.horizontal, Size.w(31))
                
                VStack(spacing: 0) {
                    Button(action: { openedFromSideMenu = true }) {
                        NavigationLink(isActive: $openedFromSideMenu, destination: {
                            ForgotPasswordView(openedFromSideMenu: $openedFromSideMenu)
                        }) { ListRow(name: "RESET_PASSWORD", noTitle: true) }.isDetailLink(false)
                    }
                    .padding(.top, Size.h(6))
                    
                    Divider()
                    
                    Button(action: {
                        withAnimation {
                            showAlert = true
                        }
                    }) {
                        ListRow(name: "LOGOUT", arrowIsOn: false, noTitle: true)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("ALERT.LOGOUT".localized()),
                              message: Text(""),
                              primaryButton: .cancel(Text("CANCEL".localized())),
                              secondaryButton: .default(Text("YES".localized()), action: { signOut() } ))
                    }
                    
                    Divider()
                    
                    ZStack {
                        if userManager.isLoading {
                            ProgressView()
                        } else {
                            Button(action: {
                                showDeleteAlert = true
                            }) {
                                ListRow(name: "DELETE_ACCOUNT", color: .red500, arrowIsOn: false, noTitle: true)
                            }
                        }
                    }
                    .padding(.bottom, Size.h(2))
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(title: Text("ALERT.DELETE_USER".localized()),
                              message: Text(""),
                              primaryButton: .cancel(Text("CANCEL".localized())),
                              secondaryButton: .destructive(Text("YES".localized()), action: { deleteUser() } ))
                    }
                }
                .tableStyle()
                //            .frame(maxWidth: .infinity, alignment: .center)
                //            .background(Color.white)
                //            .cornerRadius(Size.w(14))
                //            .padding(.horizontal, Size.w(22))
                .padding(.bottom, Size.h(184))
                
                
                NavigationLink(isActive: $openJoinScreen, destination: {
                    QRSharingView()
                }) {
                    EmptyView()
                }
            }
        }
        .navigationView(back: back, title: "SIDE.MY_ACC", bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
    }
    
    var harmonyView: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    let isAdmin = userManager.group?.role == 1
                    
                    AvatarView(user: userManager.apiNodeUser, isAdmin: isAdmin)
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 6) {
                            Text(userManager.apiNodeUser.name ?? "Unknown")
                            Text(userManager.apiNodeUser.familyName ?? "")
                        }
                        .font(semiBold20Font)
                        .foregroundColor(.gray800)
                        
                        Text(userManager.apiNodeUser.email ?? "sergey@mellowingfactory.com")
                            .font(regular14Font)
                            .foregroundColor(.gray500)
                    }
                }.padding(Size.w(20))
                Divider()
                
                if deviceManager.connectedDevice != nil {
                    
                    let current = userManager.listOfUsers.count
                    let subscription = userManager.subscription
                    if current > 0 {
                        VStack(spacing: 10) {
                            Group {
                                Text("\(subscription.plan)") + Text(" ") + Text("HARMONY_PLAN")
                            }
                            .foregroundColor(.gray400)
                            .font(regular14Font)
                            
                            let name = userManager.subscription.name ?? userManager.apiNodeUser.name ?? ""
                            let isMember = userManager.subscription.role == 0
                            
                            Text("SIDE.HARMONY_ADMIN \(name)")
                                .foregroundColor(.gray900)
                                .font(semiBold22Font)
                            
                            HStack {
                                Group {
                                    
                                    HStack {
                                        Image("logo-blue")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: Size.w(14), height: Size.h(11))
                                        Text(isMember ? "Harmony" : "Admin")
                                            .font(semiBold14Font)
                                    }
                                    .foregroundColor(.gray500)
                                    .padding(Size.w(8))
                                    .padding(.horizontal, Size.w(6))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color.gray50)
                                    )
                                }
                                
                                Group {
                                    HStack(spacing: 5) {
                                        Image("ic-person")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: Size.w(10), height: Size.w(11.5))
                                        
                                        Text("\(current) / \(subscription.maxMembers)")
                                            .tracking(-1)
                                            .font(semiBold14Font)
                                    }
                                    .foregroundColor(current >= Int(subscription.maxMembers) ?? 10 ? .yellow700 : .gray500)
                                    .padding(Size.w(8))
                                    .padding(.horizontal, Size.w(6))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color.gray50)
                                    )
                                }
                            }
                            .padding(.top, Size.h(5))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(Size.w(20))
                    } else {
                        VStack {
                            Text("SIDE.HARMONY.WARNING1")
                                .foregroundColor(.gray400)
                                .font(regular15Font)
                                .padding(.horizontal, Size.h(22))
                                .padding(.top, Size.h(26))
                                .padding(.bottom, Size.h(20))
                            
                            HStack {
                                Button(action: {
                                    if userManager.subscription.plan == "Basic" {
                                        openJoinScreen = true
                                    } else {
                                        showJoinAlert = true
                                    }
                                }) {
                                    HStack(spacing: 2) {
                                        Image("ic-harmony-join")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: Size.w(22), height: Size.w(22))
                                        Text("JOIN")
                                            .font(semiBold18Font)
                                    }
                                    .foregroundColor(.green400)
                                    .padding(.vertical, Size.w(11))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                }
                                .alert(isPresented: $showJoinAlert) {
                                    Alert(title: Text("ALERT.JOIN.WARNING"),
                                          message: Text("ALERT.JOIN.WARNING_Q"),
                                          primaryButton: .cancel(Text("CANCEL")),
                                          secondaryButton: .default(Text("YES".localized()), action: { openJoinScreen = true } ))
                                }
                                
                                Color.green400.opacity(0.4)
                                    .frame(width: 2, height: .infinity)
                                Button(action: {
                                    vc.selectedTab = 1
                                    userManager.createGroup() { _ in
                                    }
                                }) {
                                    HStack(spacing: 2) {
                                        if userManager.isLoading {
                                            ProgressView()
                                        } else {
                                            Image("ic-harmony-create")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: Size.w(22), height: Size.w(22))
                                            Text("CREATE")
                                                .font(semiBold18Font)
                                        }
                                    }
                                    .foregroundColor(.green400)
                                    .padding(.vertical, Size.w(11))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.green400.opacity(0.4), lineWidth: 2)
                            )
                            .padding(.horizontal, Size.w(20))
                            
                            .padding(.bottom, Size.h(26))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    Divider()
                    
                    
                    NavigationLink(destination: {
                        WethmHarmony()
                    }) {
                        ListRow(name: "WETHM_HARMONY", noTitle: true)
                    }
                    .padding(.bottom, Size.h(2))
                    
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        if Defaults.appLanguage != 2 {
                            VStack(alignment: .leading, spacing: -15) {
                                Text("ADV.T4.TITLE")
                                Text("ADV.T4.TITLE2")
                            }
                            .font(bold46Font)
                            .foregroundColor(.gray1100)
                            .padding(.horizontal, Size.w(26))
                            .padding(.top, Size.w(40))
                            
                            ZStack(alignment: .topLeading) {
                                Image("adv2-bg")
                                    .resizable()
                                    .scaledToFit()
                                
                                Text("ADV.T4")
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(4)
                                
                                    .font(regular14Font)
                                    .foregroundColor(.gray400)
                                    .padding(.horizontal, Size.w(26))
                                    .padding(.top)
                            }
                            Link(destination: URL(string: "https://www.kickstarter.com/projects/wethm/wethm-the-secret-to-quality-sleep")!) {
                                Text("PURCHASE")
                                    .font(medium18Font)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: Size.h(53))
                                    .background(gradientPrimaryButton)
                            }
                        }   
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.white)
            .cornerRadius(Size.w(14))
            .overlay(
                RoundedRectangle(cornerRadius: Size.w(14))
                    .stroke(Color.blue10, lineWidth: Size.h(1))
            )
            //        .shadow(color: Color.green800.opacity(0.1), radius: 20, x: -20, y: 20)
            .shadow(color: Color.blue300.opacity(userManager.subscription.plan != "Basic" ? 0.1 : 0), radius: 20, x: 20, y: 20)
            .padding(.horizontal, Size.w(16))
            .padding(.top, Size.h(32))
            .padding(.bottom, Size.h(22))
            if deviceManager.connectedDevice != nil {
                Text("ALERT.JOIN.QUES")
                    .font(regular14Font)
                    .foregroundColor(.gray300)
                    .padding(.horizontal, Size.w(31))
                    .padding(.bottom, Size.h(22))
            }
        }
    }
    
    private func back() {
        vc.navigation = nil
    }
    
    private func signOut() {
        sessionManager.signOut()
//        sessionManager.signOut {bool in
//            if bool {
//                deviceManager.connectedDevice = nil
//                userManager.apiNodeUser = ApiNodeUser()
//            }
//        }
    }
    
    private func deleteUser() {
        userManager.deleteApiUser() { response in
            if response {
                signOut()
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static let sessionManager = SessionManager()
    static let deviceManager = DeviceManager(username: "sergey@mellowingfactory.com")
    static let userManager = UserManager(username: "sergey@mellowingfactory.com", userId: "1")
    static let msc = MainScreenController()
    
    static var previews: some View {
        NavigationView {
            AccountView()
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
