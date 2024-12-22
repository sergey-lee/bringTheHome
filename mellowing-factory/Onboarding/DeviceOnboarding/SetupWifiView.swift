//
//  Step3_2View.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/05/31.
//

import SwiftUI
import Amplify

struct SetupWifiView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var onBoardProcess: BLEOnBoardPocess
    @EnvironmentObject var vc: ContentViewController
    
    @State var isDropdownShown = false
    @State var manualMode = false
    
    var wifiList: [String]
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if wifiList.isEmpty {
                Image("ic-warning")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.green300)
                    .frame(width: Size.w(22), height: Size.w(22))
                    .padding(.bottom, Size.h(10))
                
                Text("DEVCICE_ONB.TITLE8")
                    .foregroundColor(.green300)
                    .font(light16Font)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, Size.h(40))
            } else {
                Text("DEVCICE_ONB.TITLE9")
                    .font(light18Font)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .shadow(color: .black.opacity(0.1), radius: 10)
                    .padding(.bottom, Size.h(40))
            }

            if manualMode {
                WifiSSIDInputView(text: $vc.selectedOption, title: "DEVCICE_ONB.SSID")
            } else {
                WifiListView(
                    selectedOption: $vc.selectedOption,
                    isDropdownShown: $isDropdownShown,
                    wifiList: wifiList.filter { $0 != vc.selectedOption })
            }
            
            
            
//            DropdownSelector(
//                isDropdownShown: $isDropdownShown,
//                placeholder: "DEVCICE_ONB.WIFI",
//                options: wifiList,
//                selectedOption: $vc.wifiDropdownOption
//            ).zIndex(2)
            
            if !vc.selectedOption.contains("Select") && !isDropdownShown {
                WifiPasswordInputView(title: "DEVCICE_ONB.PASS", text: $vc.password)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    .zIndex(1)
                
                if manualMode {
                    Button(action: {
                        withAnimation {
                            manualMode = false
                            vc.selectedOption = "Select Wi-Fi"
                        }
                    }) {
                        Text("Show Wi-Fi list")
                            .font(regular16Font)
                            .foregroundColor(.blue400)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, Size.w(8))
                }
            } else {
                Button(action: swicthToManual) {
                    Text("DEVCICE_ONB.MANUAL_WIFI")
                        .font(regular16Font)
                        .foregroundColor(.blue400)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, Size.w(8))
                .padding(.top, Size.w(16))
            }
            
            Spacer()
            
            if !isDropdownShown {
                Text("DEVCICE_ONB.HINT6")
                    .foregroundColor(.green300)
                    .font(light16Font)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, Size.h(32))
            }
            
            if wifiList.isEmpty {
                BlueButtonView(title: "DEVCICE_ONB.TRY", action: swicthToManual)
                    .padding(.bottom, Size.h(20))
            } else {
                NavigationLink(isActive: $vc.connecting, destination: {
                    ConnectingView()
                }) { EmptyView() }.isDetailLink(false)
                
                    BlueButtonView(title: "CONNECT", action: {
                        closeKeyboard()
                        vc.connecting.toggle()
                    }, disabled: (vc.selectedOption.contains("Select")))
                    .padding(.bottom, Size.h(20))
            }
        }
        .padding(.horizontal, Size.w(16))
        .padding(.top, Size.isNotch ? 30 : 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationView(back: back, bg: LinearGradient(colors: [.blue800], startPoint: .top, endPoint: .bottom), backButtonColor: .gray100)
        .navigationBarItems(trailing: Button(action: skip) {
            Text("CANCEL")
                .font(medium16Font)
                .foregroundColor(.gray100)
        })
        .animation(.default, value: isDropdownShown)
        .onChange(of: isDropdownShown) { shown in
            if shown {
                closeKeyboard()
            }
        }
    }
    
    private func skip() {
        onBoardProcess.disconnect()
        vc.skip()
    }
    
    private func back() {
        onBoardProcess.disconnect()
        closeKeyboard()
        vc.searchDevice = false
    }
    
    private func swicthToManual() {
        withAnimation {
            isDropdownShown = false
            vc.selectedOption = ""
            manualMode = true
        }
        
//        onBoardProcess.restart { response in
//            onBoardProcess.disconnect()
//        }
//        closeKeyboard()
//        vc.searchDevice = false
    }
}

struct SetupWifiView_Previews: PreviewProvider {
    static let onBoardProcess = BLEOnBoardPocess()
    static let vc = ContentViewController()
    
    static var previews: some View {
        NavigationView {
            SetupWifiView(wifiList: [
                "wifi1",
                "wifi2",
                "wifi3",
                "wifi4",
                "wifi5",
                "wifi7",
                "wifi8",
                "wifi9",
                "wifi7",
            ])
            .environmentObject(vc)
            .environmentObject(onBoardProcess)
            .previewDevice("iPhone 11 Pro")
        }
    }
}
