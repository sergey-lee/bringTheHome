//
//  ContentViewController.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/01/09.
//

import SwiftUI
import QRCode

class ContentViewController: ObservableObject {
    @Published var selectedIndex: Int = 0
    @Published var wentToBackgroundDate = Date()
    @Published var showNotifications = false
    @Published var refresh = false
    @Published var refreshTodayScreen = false
    @Published var refreshReportScreen = false
    @Published var refreshEnhanceScreen = false
    @Published var state: ContentState = .none
    @Published var selectedTab: Int = 2
    @Published var showSideMenu = false
    @Published var navigation: String? = nil
    
    @Published var timer: Timer? = nil
    @Published var expired = false
    @Published var validTimer: Int = qrCodeExpTime
    @Published var counter: Timer? = nil
    @Published var qrcode: QRCode.Document? = nil
    @Published var qrImage: UIImage? = nil
    
    @Published var showBottomBar = true
    
    // MARK: Refreshing Pages on Double Tap
    func resetPageState() {
        switch self.selectedIndex {
        case 0: refreshTodayScreen.toggle()
        case 1: refreshReportScreen.toggle()
        case 2: refreshEnhanceScreen.toggle()
        default: return
        }
    }
    
    @ViewBuilder
    func getState() -> some View {
        switch state {
        case .sleepModeIOT:
            SleepWindow().environmentObject(self)
        case .QRScanner:
            ScanQRView()
        case .joinSuccess:
            JoinSuccessView()
        case .coach(let type):
            CoachingMarks(type: type).environmentObject(self)
        default:
            EmptyView()
        }
    }
    
    func startListening(userManager: UserManager) {
        startTimer()
        guard self.timer == nil else { return }
        self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { timer in
            if !self.expired {
                userManager.getGroup() { success in
                    if !userManager.listOfUsers.isEmpty {
                        withAnimation(.easeOut(duration: 0.5)) {
                            self.timer?.invalidate()
                            self.counter?.invalidate()
                            self.timer = nil
                            self.counter = nil
                            self.navigation = nil
                            self.showSideMenu = false
                            self.state = .joinSuccess
                            self.selectedTab = 1
                        }
                    }
                }
            }
        })
    }
    
    private func startTimer() {
        guard self.counter == nil else { return }
        self.counter = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if !self.expired {
                if self.validTimer > 1 {
                    self.validTimer -= 1
                } else {
                    self.timer?.invalidate()
                    self.counter?.invalidate()
                    self.timer = nil
                    self.counter = nil
                    withAnimation {
                        self.expired = true
                    }
                }
            }
        })
    }
    
    //MARK: Device Onboading elements:
    @Published var step2: Bool = false
    @Published var searchDevice: Bool = false
    @Published var connecting: Bool = false
    @Published var check: Bool = false
    @Published var startChecking: Bool = false
    @Published var intensityStep2: Bool = false
    
//    @Published var wifiName: String = ""
    @Published var password: String = ""
    @Published var wifiDropdownOption: DropdownOption? = nil
    @Published var selectedOption: String = "Select Wi-Fi"
    
    func skip() {
        self.step2 = false
        self.searchDevice = false
        self.connecting = false
    }
    
    // MARK: Settings elements:
    @Published var openAlarmSettings: Bool = false
    @Published var checkDevice = false
    
    func resetCheckNavigations() {
        self.openAlarmSettings = false
        self.startChecking = false
        self.checkDevice = false
    }
}

enum ContentState: Equatable {
    case none
    case sleepModeIOT
    case QRScanner
    case joinSuccess
    case coach(type: CoachType)
}
