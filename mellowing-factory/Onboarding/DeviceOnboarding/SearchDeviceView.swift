//
//  SearchDeviceView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/02.
//

import SwiftUI
import Amplify

struct SearchDeviceView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var onBoardProcess: BLEOnBoardPocess
    @EnvironmentObject var vc: ContentViewController
    
    @State var isLoadingNetworks = false
    @State var wifiList: [String] = []
    @State var nextStep = false
    @State var connectionIssue = false
    @State var degrees: CGFloat = 0
    @State var startLightAnimation = false
    
    var body: some View {
        ZStack {
            AnimatedBG(image: "lights2-bg").ignoresSafeArea()
            
            VStack(alignment: .center, spacing: Size.isNotch ? 20 : 10) {
                VStack(alignment: .leading, spacing: Size.h(16)) {
                    Image("wethm-logo-text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 32)
                    (Text("DEVCICE_ONB.TITLE7") + Text(Image("wethm_58_13")) + Text("DEVCICE_ONB.TITLE7.0"))
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
                        .rotationEffect(Angle(degrees: degrees))
                    Image("ic-bluetooth")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Size.w(46), height: Size.w(46))
                        .frame(width: Size.w(200), height: Size.w(200))
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text(LocalizedStringKey("DEVCICE_ONB.TITLE7.1"))
                    .font(light16Font)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.bottom, Size.w(32))
            }.padding(.horizontal, Size.w(22))
        }
        .navigationView(backButtonHidden: true)
        .navigationBarItems(trailing: Button(action: back) {
            Text("CANCEL")
                .font(medium16Font)
                .foregroundColor(.gray100)
        })
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 1).repeatForever()) {
                    startLightAnimation = true
                }
                withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                    degrees = 360
                }
                getWifiList()
            }
        }
        
        NavigationLink(isActive: $nextStep, destination: {
            SetupWifiView(wifiList: self.wifiList)
        }) { EmptyView() }.isDetailLink(false)
        
        NavigationLink(isActive: $connectionIssue, destination: {
            ConnectionIssueView(type: .bluetooth)
        }) { EmptyView() }.isDetailLink(false)
    }

    private func getWifiList() {
        isLoadingNetworks = true
        onBoardProcess.connectAndGetWifiList { onBoardResult in
            self.wifiList = onBoardResult.wifiList
//            self.wifiList = onBoardResult.wifiList.map {
//                DropdownOption(key: UUID().uuidString, value: "\($0)")
//            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                vc.selectedOption = self.wifiList.first ?? "Select Wi-Fi"
//                vc.wifiDropdownOption = self.wifiList.first
                if !wifiList.isEmpty {
                    print("sending: \(self.wifiList)")
                    nextStep = true
                } else {
                    print("error during fetching wifi list from the device")
                    connectionIssue = true
                }
            }
            isLoadingNetworks = false
        }
    }
    
    private func back() {
        vc.searchDevice = false
//        self.presentationMode.wrappedValue.dismiss()
    }
}

struct SearchDeviceView_Previews: PreviewProvider {
    static let onBoardProcess = BLEOnBoardPocess()
    static let vc = ContentViewController()
    static var previews: some View {
//        NavigationView {
            SearchDeviceView()
                .environmentObject(onBoardProcess)
                .environmentObject(vc)
                .environment(\.locale, .init(identifier: "en"))
//        }
    }
}
