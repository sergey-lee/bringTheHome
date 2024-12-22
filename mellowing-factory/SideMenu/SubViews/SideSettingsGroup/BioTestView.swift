//
//  BioTestView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/07/11.
//

import SwiftUI

struct BioTestView: View {
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
    @State var coundtown = 60
    @State var bpm: String? = nil
    
    private let apiNodeServer = ApiNodeServer()

    var body: some View {
        ZStack {
            AnimatedBG(image: "lights3-bg").ignoresSafeArea()
            
            VStack(alignment: .center, spacing: Size.isNotch ? 20 : 10) {
                VStack(alignment: .leading, spacing: Size.h(16)) {
                    HStack {
                        Text("Heart Rate:")
                            .foregroundColor(.white)
                            .font(semiBold24Font)
                        if let bpm {
                            Text(bpm)
                                .foregroundColor(.white)
                                .font(semiBold24Font)
                        }
                    }
                    
                    
                    Image("wethm-logo-text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 32)
                    
                    Text("The **Sleep Enhancer** is\nmeasuring your Biosignals.\nPlease wait a moment... \(coundtown)")
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
            Text("cancel")
                .font(medium16Font)
                .foregroundColor(.gray100)
        })
        .onAppear {
//            withAnimation {
//                vc.showBottomBar = false
//            }
            
            startAnimationChain()
        }
        .onChange(of: coundtown) { count in
            if count == 45 {
                checkDevice()
            }
            if count == 30 {
                checkDevice()
            }
            if count == 15 {
                checkDevice()
            }
            if count == 0 {
                checkDevice()
            }
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
            }
        }.fire()
    }
    
    func checkDevice() {
        if let device = deviceManager.connectedDevice {
            apiNodeServer.testBio(deviceId: device.id) { result in
                switch result {
                case .success(let listOfSensorData):
                    let listOfBPMs = listOfSensorData.map{ $0.heartRate }.filter{ $0 > 0 }
                    self.bpm = listOfBPMs.isEmpty ? "Not detected" : String(calculateMedian(array: listOfBPMs))
//                    print(listOfBPMs)
//                    print(self.bpm)
                    
                case .failure:
                    print("No data")
//                    navigateToIssue = true
                }
            }
        } else {
            print("No device")
//            navigateToIssue = true
        }
    }
    
    func calculateMedian(array: [Int]) -> Float {
        let sorted = array.sorted()
        if sorted.count % 2 == 0 {
            return Float((sorted[(sorted.count / 2)] + sorted[(sorted.count / 2) - 1])) / 2
        } else {
            return Float(sorted[(sorted.count - 1) / 2])
        }
    }
    
//    func checkDevice() {
//        if let device = deviceManager.connectedDevice {
//            apiNodeServer.checkDevice(deviceId: device.id) { result in
//                switch result {
//                case .success(let listOfSensorData):
//                    if listOfSensorData.isEmpty {
//                        print("List is empty")
//                        navigateToIssue = true
//                    } else {
//                        let summ = listOfSensorData.reduce(0, { $0 + $1.valid })
//                        print("Summ of all valid values is: \(summ)")
//                        if summ >= 4 {
//                            navigateToComplete = true
//                        } else {
//                            navigateToIssue = true
//                        }
//                    }
//                    print("Data is fetched")
//                case .failure:
//                    print("No data")
//                    navigateToIssue = true
//                }
//            }
//        } else {
//            print("No device")
//            navigateToIssue = true
//        }
//    }

    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct BioTestView_Previews: PreviewProvider {
    static let onboardingProcess = BLEOnBoardPocess()
    static let vc = ContentViewController()
    
    static var previews: some View {
        Group {
            BioTestView()
                .environmentObject(vc)
                .environmentObject(onboardingProcess)
                .previewDevice("iPhone 11 Pro")
        }
    }
}
