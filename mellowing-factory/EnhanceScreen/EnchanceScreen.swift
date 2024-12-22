//
//  EnhanceScreen.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/30.
//

import SwiftUI

struct EnhanceScreen: View {
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var vc: ContentViewController
//
//    @State var sleepInductionIsOn = false
//    @State var smartActivation = false
//    @State var buttonActivation = true
//    @State var strength = 6
//    @State var frequency = 6
    
    @State var scrolledUp = false
    @State var offset: CGFloat = 0
    @State var isLoading = false
    @State var sleepInductionStarted = false
    
    var body: some View {
        NavigationView {
            ZStack {
                TrackableScrollView(showIndicators: false, contentOffset: $offset) {
                    ScrollViewReader { reader in
                        VStack(spacing: 0) {
                            EmptyView()
                                .frame(height: 1)
                                .id("top")
                            SleepInductionView(isLoading: $isLoading, sleepInductionStarted: $sleepInductionStarted)
                            SmartAlarmView(isLoading: $isLoading)
                                .disabled(sleepInductionStarted)
                                .brightness(sleepInductionStarted ? -0.2 : 0)
                                .blur(radius: sleepInductionStarted ? 1 : 0)
                                .onChange(of: vc.refreshEnhanceScreen) { _ in
                                    withAnimation {
                                        reader.scrollTo("top")
                                    }
                                }
                            Spacer().frame(height: Size.h(200))
                        }
                        .disabled(isLoading)
                    }
                }
                .background(gradientBackground).ignoresSafeArea()
                .navigationView(title: "ENHANCE", backButtonHidden: true)
                .navigationBarHidden(!scrolledUp)
                .animation(.default, value: isLoading)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if !Defaults.enhanceWasShown {
                            withAnimation {
                                vc.state = .coach(type: .enhance)
                            }
                        }
                    }
                }
                .onChange(of: offset) { value in
                    withAnimation {
                        scrolledUp = value > Size.h(150)
                    }
                }
                
                if isLoading {
                    LoadingBox()
                        .padding(.bottom, Size.w(13))
                }
            }
        }
    }
}

struct EnhanceScreen_Previews: PreviewProvider {
    static var deviceManager = DeviceManager(username: "Tester")
    static var vc = ContentViewController()
    
    static var previews: some View {
        EnhanceScreen()
            .environmentObject(vc)
            .environmentObject(deviceManager)
    }
}
