//
//  CheckingProcessView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/19.
//

import SwiftUI

struct CheckingProcessView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var vc: ContentViewController
    
    @State var degrees: CGFloat = 0
    @State var animation1 = false
    @State var animation2 = false
    
    @State var navigateToIssue = false
    @State var navigateToComplete = false
    
    @State var width: CGFloat = 3
    @State var width2: CGFloat = 3
    @State var coundtown = 65
    @State var checked = false
    
    private let apiNodeServer = ApiNodeServer()
    
    var body: some View {
        ZStack {
            AnimatedBG(image: "lights3-bg").ignoresSafeArea()
            
            VStack(alignment: .center, spacing: Size.isNotch ? 20 : 10) {
                VStack(alignment: .leading, spacing: Size.h(16)) {
                    Image("wethm-logo-text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 32)
                    
                    Group {
                        Text("DEVCICE_ONB.TITLE16") + Text(String(coundtown))
                    }
                    .font(light18Font)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 10)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Size.w(8))
                .padding(.top, Size.h(56))
                .padding(.bottom, Size.h(100))
                .padding(.horizontal, Size.w(22))
                
                ZStack {
                    HStack {
                        line.opacity(animation1 ? 0 : 1)
                        
                        Spacer()
                        line.rotationEffect(Angle(degrees: 180)).opacity(animation2 ? 0 : 1)
                    }
                    
                    ZStack {
                        GradientRing(animation: .constant(false), width: width, lightIsOn: true, size: 264)
                            .rotationEffect(Angle(degrees: -90))
                        GradientRing(animation: .constant(false), width: width, lightIsOn: true, size: 264)
                            .rotationEffect(Angle(degrees: 90))
                        
                    }.opacity(animation2 ? 0 : 1)
                    ZStack {
                        GradientRing(animation: .constant(false), width: width2, lightIsOn: true, size: 264)
                            .rotationEffect(Angle(degrees: -90))
                        GradientRing(animation: .constant(false), width: width2, lightIsOn: true, size: 264)
                            .rotationEffect(Angle(degrees: 90))
                    }.opacity(animation1 ? 0 : 1)
                    
                    ZStack {
                        GradientRing(animation: .constant(false), lightIsOn: false, size: 200)
                        GradientRing(animation: .constant(false), lightIsOn: false, size: 200)
                            .rotationEffect(Angle(degrees: 180))
                    }
                    .rotationEffect(Angle(degrees: 30))
                    .rotationEffect(Angle(degrees: degrees))
                    
                    ZStack {
                        Image("wethm-logo-white")
                            .resizable()
                            .scaledToFit()
                            .frame(width: Size.w(50), height: Size.w(40))
                            .opacity(animation1 ? 0 : 1)
                        Image("wethm-logo-white")
                            .resizable()
                            .scaledToFit()
                            .frame(width: Size.w(50), height: Size.w(40))
                            .opacity(animation2 ? 0 : 1)
                    }
                    .frame(width: Size.w(200), height: Size.w(200))
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
                }
                
                Spacer()
            }
        }
        .navigationView(backButtonHidden: true)
        .navigationBarItems(trailing: Button(action: back) {
            Text("CANCEL")
                .font(medium16Font)
                .foregroundColor(.gray100)
        })
        .onAppear {
            startAnimationChain()
        }
        
        NavigationLink(isActive: $navigateToIssue, destination: {
            CheckIssueView()
        }) { EmptyView() }.isDetailLink(false)
        
        NavigationLink(isActive: $navigateToComplete, destination: {
            CheckCompletedView()
        }) { EmptyView() }.isDetailLink(false)
    }
    
    var line: some View {
        HStack(spacing: 0) {
            Color.white.frame(width: Size.w(87), height: 1)
            Ellipse()
                .fill(Color.white)
                .frame(width: 2.3, height: 5.5)
                .opacity(0.8)
                .overlay(
                    Ellipse()
                        .fill(Color.white)
                        .frame(width: 4, height: 20)
                        .blur(radius: 3)
                        .shadow(color: .white, radius: 5)
                )
        }
    }
    
    private func startAnimationChain() {
        withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
            degrees = 360
        }
        withAnimation(.easeOut(duration: 4).repeatForever(autoreverses: false)
        ) {
            width = 0.5
            animation1 = true
        }
        
        withAnimation(.easeOut(duration: 4).repeatForever(autoreverses: false).delay(2)
        ) {
            width2 = 0.5
            animation2 = true
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if coundtown > 0 {
                self.coundtown -= 1
            } else {
                if !checked {
                    checkDevice()
                }
            }
        }.fire()
    }
    
    func checkDevice() {
        guard let device = deviceManager.connectedDevice else {
            print("No device")
            navigateToIssue = true
            return
        }
        
        apiNodeServer.checkDevice(deviceId: device.id) { result in
            switch result {
            case .success(let listOfSensorData):
                guard !listOfSensorData.isEmpty else {
                    print("List is empty")
                    navigateToIssue = true
                    return
                }
                
                let summ = listOfSensorData.reduce(0, { $0 + $1.valid })
                print("Summ of all valid values is: \(summ)")
                if summ >= 4 {
                    navigateToComplete = true
                } else {
                    navigateToIssue = true
                }
                
                print("Data is fetched")
            case .failure:
                print("No data")
                navigateToIssue = true
            }
            self.checked = true
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct CheckingProcessView_Previews: PreviewProvider {
    static let onboardingProcess = BLEOnBoardPocess()
    static let vc = ContentViewController()
    
    static var previews: some View {
        Group {
            CheckingProcessView()
                .environmentObject(vc)
                .environmentObject(onboardingProcess)
                .previewDevice("iPhone 11 Pro")
        }
    }
}
