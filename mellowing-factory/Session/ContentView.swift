//
//  ContentView.swift
//  mellowing-factory
//
//  Created by Florian Topf on 31.07.21.
//

import SwiftUI
import Amplify

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var msc: MainScreenController
    @StateObject var weekStore = WeekStore()
    
    var body: some View {
        ZStack {
            BottomTabBar(tabs: TabBarType.allCases.map({ $0.tabItem }),
                         titles: TabBarType.allCases.map({ $0.tabTitle })
            ) { index in
                getTabView(index: index)
            }
            SideMenu()
            NotificationsView()
            vc.getState()
        }
        .environmentObject(weekStore)
        .ignoresSafeArea()
        .onAppear {
            deviceManager.wasStopped = false
            deviceManager.startCheckingDeviceConnection(timerInterval: 60)
            let notificationManager = NotificationManager()
            
            notificationManager.requestPermission { _ in }
            
            // MARK: Setting .gray700 for NavBarTitle, Content View
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.gray700)]
        }
        .onDisappear {
            // MARK: Setting .white for NavBarTitle, SignUp ViewGroup
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.white)]
            deviceManager.wasStopped = true
        }
        .onChange(of: scenePhase) { newPhase in
            autoUpdate(newPhase: newPhase)
        }
        .onReceive(deviceManager.$currentTimer) { timer in
            if vc.state == .none || vc.state == .sleepModeIOT {
                if timer != nil {
                    vc.state = .sleepModeIOT
                } else {
                    vc.state = .none
                }
            }
        }
        .onOpenURL{ url in
            if url.absoluteString.contains("account") {
                withAnimation {
                    vc.showSideMenu = true
                    vc.navigation = "account"
                }
            } else if url.absoluteString.contains("settings") {
                withAnimation {
                    vc.showSideMenu = true
                    vc.navigation = "account"
                }
            }
        }
    }
    
    @ViewBuilder
    func getTabView(index: Int) -> some View {
        let type = TabBarType(rawValue: index) ?? .main
        
        switch type {
        case .main:
            TodayScreen()
        case .report:
            ReportView()
        case .alarm:
            EnhanceScreen()
        }
    }
    
    func autoUpdate(newPhase: ScenePhase) {
        switch newPhase {
        case .background:
            deviceManager.wasStopped = true
            print("ContentView: Background")
        case .inactive:
            print("ContentView: Inactive")
        case .active:
            print("ContentView: Active")
            // MARK: setup current timer to display SleepModeIOTView
            deviceManager.setCurrentTimer()
            deviceManager.wasStopped = false
            // MARK: Checks if 15 minutes passed after last App activation and refresh all data
            if Date() > Calendar.current.date(byAdding: .minute, value: 15, to: vc.wentToBackgroundDate)! {
                weekStore.selectedDate = Date().startOfDay
                vc.showSideMenu = false
                vc.navigation = nil
                vc.refresh.toggle()
                vc.wentToBackgroundDate = Date()
                userManager.refresh()
                deviceManager.fetchData()
                msc.refresh()
                print("ContentView: all data refreshed")
            }
        @unknown default:
            print("Unknown phase")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            .previewDevice("iPhone 11 Pro")
        }
    }
}
