//
//  Step3_4View.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/02.
//

import SwiftUI
import Amplify

struct ConnectingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var onBoardProcess: BLEOnBoardPocess
    
    @State var onboardResult = OnBoardResult(data: nil)
    @State var connectIssue = false
    @State var wrongWifiData = false
    @State var completed = false
    
    @State var degrees: CGFloat = 0
    @State var startLightAnimation = false
    @State var step1Animation = false
    @State var step2Animation = false
    @State var step3Animation = false
    @State var brightness: CGFloat = 0
    
    @State var ssid: String = ""
    @State var subtitle: LocalizedStringKey = "DEVCICE_ONB.TITLE10"
    @State var hint: LocalizedStringKey = "DEVCICE_ONB.HINT7"
    
    var body: some View {
        ZStack {
            AnimatedBG(image: "lights3-bg").ignoresSafeArea()
            
            VStack(alignment: .center, spacing: Size.isNotch ? 20 : 10) {
                VStack(alignment: .leading, spacing: Size.h(16)) {
                    Image("wethm-logo-text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 32)
                    
                    Text(subtitle)
                        .font(light18Font)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 10)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Size.w(8))
                .padding(.top, Size.h(50))
                .padding(.bottom, Size.h(100))
                
                ZStack {
                    
                    GradientRing(animation: $startLightAnimation, lightIsOn: true, size: 264)
                        .opacity(step2Animation ? 0 : 1)
                        .rotationEffect(Angle(degrees: degrees))
                    GradientRing(animation: $startLightAnimation, lightIsOn: true, size: 264)
                        .opacity(step2Animation ? 0 : 1)
                        .rotationEffect(Angle(degrees: -degrees))
                    
                    GradientRing(animation: $startLightAnimation, size: 264)
                        .rotationEffect(Angle(degrees: step1Animation ? 540 : 0))
                        .opacity(0.5)
                        .opacity(step2Animation ? 1 : 0)
                        .opacity(step3Animation ? 0 : 1)
                    GradientRing(animation: $startLightAnimation, size: 264)
                        .rotationEffect(Angle(degrees: step1Animation ? -540 : 0))
                        .opacity(0.5)
                        .opacity(step2Animation ? 1 : 0)
                        .opacity(step3Animation ? 0 : 1)

                    Color.green100.opacity(0.1)
                        .frame(width: Size.w(264), height: Size.w(264))
                        .clipShape(Circle())
                        .brightness(brightness)
                        .overlay(
                            Circle()
                                .stroke(Color.green100, lineWidth: 1)
                                .opacity(0.3)
                        )
                        .opacity(step3Animation ? 1 : 0)
                    
                    Image("wethm-logo-white")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Size.w(50), height: Size.w(40))
                        .opacity(step1Animation ? 1 : 0)
                    
                    Blur(intensity: 0.2)
                        .frame(width: Size.w(200), height: Size.w(200))
                        .clipShape(Circle())
                        .opacity(step1Animation ? 0 : 1)
                    
                    GradientRing(animation: $startLightAnimation, size: 200)
                        .rotationEffect(Angle(degrees: step1Animation ? 540 : 0))
                        .opacity(step2Animation ? 1 : 0)
                        .opacity(step3Animation ? 0 : 1)
                    GradientRing(animation: $startLightAnimation, size: 200)
                        .rotationEffect(Angle(degrees: step1Animation ? -540 : 0))
                        .opacity(step2Animation ? 1 : 0)
                        .opacity(step3Animation ? 0 : 1)

                    Circle()
                        .stroke(Color.green100, lineWidth: 2)
                        .frame(width: Size.w(200), height: Size.w(200))
                        .opacity(step3Animation ? 1 : 0)
                        .brightness(brightness)
                }
                
                Spacer()
                
                
                
                Text(hint)
                    .foregroundColor(.white.opacity(0.5))
                    .font(light16Font)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, Size.w(32))
                
            }.padding(.horizontal, Size.w(22))
            
            NavigationLink(isActive: $connectIssue, destination: {
                ConnectionIssueView()
            }) { EmptyView() }.isDetailLink(false)
            
            NavigationLink(isActive: $wrongWifiData, destination: {
                WrongDataView(ssid: ssid)
            }) { EmptyView() }.isDetailLink(false)
            
            NavigationLink(isActive: $completed, destination: {
                WarningView()
            }) { EmptyView() }.isDetailLink(false)
        }
        .navigationView(backButtonHidden: true)
        .navigationBarItems(trailing: Button(action: back) {
            Text("CANCEL")
                .font(medium16Font)
                .foregroundColor(.gray100)
        })
        .onAppear {
            onboardDevice()
            withAnimation(.easeInOut(duration: 1).repeatForever()) {
                startLightAnimation = true
            }
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                degrees = 360
            }
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func onboardDevice() {
        onboardResult = OnBoardResult(data: nil)
        guard !vc.selectedOption.contains("Select") else {
            wrongWifiData.toggle()
            return
        }
        self.ssid = vc.selectedOption
//        self.ssid = vc.wifiDropdownOption != nil ? vc.wifiDropdownOption!.value : vc.wifiName
        print("connecting to \(ssid)")
        onBoardProcess.onBoardDevice(username: userManager.username, ssid: ssid, pass: vc.password) { onBoardResult in
            print("onBoardResult: ", onBoardResult.toMap)
            self.onboardResult = onBoardResult
            if onboardResult.code == DEVICE_CANNOT_CONNECT_WIFI {
                
                print("Error while connection to the wifi: \(ssid), password: \(vc.password)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    wrongWifiData.toggle()
                }
            } else if onboardResult.code == DEVICE_SUCCESS_0 || onboardResult.code == DEVICE_SUCCESS {
                withAnimation {
                    self.subtitle = "DEVCICE_ONB.TITLE10-1"
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    withAnimation {
                        self.hint = "DEVCICE_ONB.HINT7-1"
                    }
                    withAnimation(.linear(duration: 3).delay(2)) {
                        step1Animation = true
                    }
                    withAnimation(.linear.delay(2)) {
                        step2Animation = true
                    }
                    withAnimation(.linear(duration: 1).delay(4)) {
                        step3Animation = true
                    }
                    withAnimation(.linear.delay(4)) {
                        brightness = 1
                    }
                    withAnimation(.linear.delay(5)) {
                        brightness = 0
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 16) {
                    deviceManager.connectedDevice = onboardResult.data
                    // MARK: Hardcoded default mode: 1
//                    deviceManager.updateIotDevice(mode: 1) { result in
//                        switch result {
//                        case true:
//                            print("mode updated to 1")
//                        case false:
//                            print("Error while updating device")
//                        }
//                    }
                    deviceManager.deviceStatus = .connected
//                    Defaults.wifiName = vc.wifiDropdownOption?.value ?? vc.wifiName
                    Defaults.wifiName = vc.selectedOption
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        completed.toggle()
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    connectIssue.toggle()
                }
            }
        }
    }
}

struct ConnectingView_Previews: PreviewProvider {
    static let onBoardProcess = BLEOnBoardPocess()
    static let vc = ContentViewController()
    static let deviceManager = DeviceManager(username: "asdf")
    static let userManager = UserManager(username: "asdf", userId: "1")
    
    
    static var previews: some View {
        Group {
            ConnectingView()
                .environmentObject(onBoardProcess)
                .environmentObject(vc)
                .environmentObject(deviceManager)
                .environmentObject(userManager)
            
            .previewDevice("iPhone 11 Pro")
        }
    }
}
