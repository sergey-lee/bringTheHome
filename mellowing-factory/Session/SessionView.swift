//
//  SessionView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/12/22.
//

import SwiftUI
import Amplify

struct SessionView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject var deviceManager: DeviceManager
    @StateObject var userManager: UserManager
    @StateObject var msc: MainScreenController
    @StateObject var vc = ContentViewController()
    @StateObject var onBoardPocess = BLEOnBoardPocess()
    
    var body: some View {
        ZStack {
            if deviceManager.fetching || msc.isLoading || userManager.fetching {
                LogoLoadingView()
            } else if deviceManager.error {
                GeneralErrorView(action: { deviceManager.update() })
            } else {
                /// contact@mellowingfactory.com - for manufacturing tests
                if userManager.username == "10bad263-845b-460d-8f6f-bdf3eac5cde2" ||
                    userManager.apiNodeUser.email == "contact@mellowingfactory.com" ||
                    userManager.username == "82a67042-0308-49a5-a762-152310145740" ||
                    userManager.apiNodeUser.email == "joonnnyonglee@melab.snu.ac.kr" ||
                    userManager.username == "ae1a39ca-7370-439a-b094-61d18c5fa003" ||
                    userManager.apiNodeUser.email == "joonnnyong@naver.com" {
                    
                    BleTestView()
                } else {
                    if !deviceManager.isOnboarded {
//                        OnboardingView()
                        NewBleView()
                    } else if deviceManager.checking || deviceManager.needUpdate  {
                        UpdatingView()
                    } else if !(deviceManager.connectedDevice?.isTested ?? true) {
                        CompletedView()
                    } else {
                        ContentView()
                    }
                }
            }
        }
        .environmentObject(deviceManager)
        .environmentObject(userManager)
        .environmentObject(vc)
        .environmentObject(msc)
        .environmentObject(onBoardPocess)
        .environment(\.locale, .init(identifier: languageList[sessionManager.appLanguage].loc))
    }
}
