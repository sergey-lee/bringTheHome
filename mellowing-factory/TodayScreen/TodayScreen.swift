//
//  MainScreen.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/01/30.
//

import SwiftUI

struct TodayScreen: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var msc: MainScreenController
    
    @State var showRemovedAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MenuView()
                ZStack {
                    if !userManager.listOfUsers.isEmpty {
                        ScrollView(.init()) {
                            TabView(selection: $vc.selectedTab) {
                                FamilyTab()
                                    .tag(1)
                                
                                MySleepTab()
                                    .tag(2)
                            }.tabViewStyle(.page(indexDisplayMode: .never))
                        }.ignoresSafeArea()
                    } else {
                        MySleepTab()
                            .tag(2)
                    }
                    
                    headerBox
                    
                    if showRemovedAlert {
                        RemovedAlertView(showRemovedAlert: $showRemovedAlert)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarHidden(true)
            .background(gradientBackground.ignoresSafeArea())
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    // TODO: FIXME, because it's appearing even for an admin
                    showRemovedAlert = Defaults.adminName?.contains("removed") ?? false
                }
            }
            .onReceive(vc.$refreshTodayScreen) { _ in
                withAnimation {
                    vc.selectedTab = 2
                }
            }
        }
    }
    
    var headerBox: some View {
        VStack(spacing: 0) {
            if !userManager.listOfUsers.isEmpty {
                VStack(spacing: Size.h(5)) {
                    Text(Date().toString(dateFormat: "YYYY MMM dd"))
                        .font(regular14Font)
                        .opacity(0.4)
                    Text(vc.selectedTab == 2 ? "MY_SLEEP" : "MY_HARMONY")
                        .font(semiBold24Font)
                        .padding(.bottom, Size.h(5))
                        HStack {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: 20, height: 3)
                                .opacity(vc.selectedTab == 1 ? 1 : 0.3)
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: 20, height: 3)
                                .opacity(vc.selectedTab == 2 ? 1 : 0.3)
                        }
                }
                .frame(height: vc.selectedTab == 1 ?  (msc.pulledUp ? 0 : Size.h(80)) : (msc.details ? 0 : Size.h(80)), alignment: .top)
                .opacity(vc.selectedTab == 1 ?  (msc.pulledUp ? 0 : 1) : (msc.details ? 0 : 1))
                .foregroundColor(.gray1100)
            } else {
                VStack(spacing: Size.h(5)) {
                    Text(Date().toString(dateFormat: "YYYY MMM dd"))
                        .font(regular14Font)
                        .opacity(0.4)
                    Text("MY_SLEEP")
                        .font(semiBold24Font)
                        .padding(.bottom, Size.h(5))
                }
                .frame(height: msc.details ? 0 : Size.h(80), alignment: .top)
                .opacity(msc.details ? 0 : 1)
                .foregroundColor(.gray1100)
            }
            Spacer()
        }
    }
}

struct TodayScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TodayScreen()
                .environmentObject(UserManager(username: "", userId: ""))
                .environmentObject(DeviceManager(username: ""))
                .environmentObject(ContentViewController())
                .environmentObject(MainScreenController())
        }
    }
}
