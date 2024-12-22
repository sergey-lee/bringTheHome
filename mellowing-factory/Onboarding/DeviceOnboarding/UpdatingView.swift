//
//  UpdatingView.swift
//  mellowing-factory
//
//  Created by 이준녕 on 11/27/23.
//

import SwiftUI

import SwiftUI
import Amplify

struct UpdatingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var vc: ContentViewController
    
    @State var degrees: CGFloat = 0
    @State var startLightAnimation = false
    @State var step1Animation = false
    @State var step2Animation = false
    @State var step3Animation = false
    @State var brightness: CGFloat = 0
    
    @State var timer: Timer? = nil
    @State var requestTimer: Timer? = nil
    @State var countDown: Int = updatingTime
    
    var body: some View {
        ZStack {
            AnimatedBG(image: "lights3-bg").ignoresSafeArea()
            
            VStack(alignment: .center, spacing: Size.isNotch ? 20 : 10) {
                VStack(alignment: .leading, spacing: Size.h(16)) {
                    Image("wethm-logo-text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 32)
                    
                    Text("DEVCICE_ONB.TITLE28")
                        .font(light18Font)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 10)
                    countDown.secondsToMinutesSecondsText()
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
                    
                    Blur(intensity: 0.2)
                        .frame(width: Size.w(200), height: Size.w(200))
                        .clipShape(Circle())
                        .opacity(step1Animation ? 0 : 1)
                    
                    let opacity = step1Animation ? 1 : 1.1 - (Double(countDown) / 300)
                    
                    Image("ic-device-updating")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Size.w(46), height: Size.w(68))
                        .opacity(opacity)
                    
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
                
                Text("DEVCICE_ONB.TITLE29")
                    .foregroundColor(.white.opacity(0.5))
                    .font(light16Font)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, Size.w(32))
                
            }.padding(.horizontal, Size.w(22))
        }
        .navigationView(backButtonHidden: true)
        .onAppear {
            initialize()
        }
        .onDisappear {
            self.timer?.invalidate()
            self.requestTimer?.invalidate()
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func initialize() {
        withAnimation(.easeInOut(duration: 1).repeatForever()) {
            startLightAnimation = true
        }
        withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
            degrees = 360
        }
        if let device = deviceManager.connectedDevice {
            if let createdDate = device.created?.convertToDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
                let diffs = Calendar.current.dateComponents([.hour, .minute, .second], from: createdDate.plusOffset(), to: Date())
                if let hours = diffs.hour, let minutes = diffs.minute, let seconds = diffs.second {
                    let secondsPassedFromOnboarding = (hours * 60 * 60) + (minutes * 60)  + seconds
                    if secondsPassedFromOnboarding < countDown {
                        self.countDown = updatingTime - secondsPassedFromOnboarding
                        print(self.countDown)
                    } else {
                        self.countDown = 0
                    }
                }
            }
        }
        
        guard self.timer == nil else { return }
        let interval: Double = 1
        if self.countDown > 1 {
            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { timer in
                self.countDown = countDown - 1
            })
        }
        
        guard self.requestTimer == nil else { return }
        let requestInterval: Double = 10
        self.requestTimer = Timer.scheduledTimer(withTimeInterval: requestInterval, repeats: true, block: { timer in
            deviceManager.checkIfIsUpdated { isUpdated in
                if isUpdated {
                    onSuccess()
                }
            }
        })
    }
    
    func onSuccess() {
        self.timer?.invalidate()
        self.requestTimer?.invalidate()
        print("Successfully updated")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            let notificationManager = NotificationManager()
            deviceManager.check()
            notificationManager.requestPermission { _ in}
        }
    }
}

struct UpdatingView_Previews: PreviewProvider {
    static let deviceManager = DeviceManager(username: "asdf")
    
    
    static var previews: some View {
        Group {
            UpdatingView()
                .environmentObject(deviceManager)
        }
    }
}
