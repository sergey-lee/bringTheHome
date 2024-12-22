//
//  Step6View.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/25.
//

import SwiftUI

struct Step6View: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var vc: ContentViewController

    @State var showAlert = false
    @State var isLoadingNetworks = false
    @State var showWarning = false
    @State var wifiList: [String] = [""]
    @State var animation = false
    
    var bleController = BLEController()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                Text("DEVCICE_ONB.TITLE6")
                    .font(light18Font)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, Size.w(14))
                    .shadow(color: .black.opacity(0.1), radius: 10)
                
                Spacer()
                ZStack {
                    Image("device-power")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        
                    Circle()
                        .fill(Color.blue500)
                        .frame(width: Size.w(10), height: Size.w(10))
                        .blur(radius: 3.5)
                        .offset(x: Size.w(-38), y: 3)
                        .opacity(animation ? 0 : 1)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.linear(duration: 0.15).repeatForever(autoreverses: true)) {
                                    self.animation = true
                                }
                            }
                        }
                }
                .frame(width: Size.w(375), height: Size.w(340))
                .padding(.horizontal, Size.w(-32))
                
                Text("DEVCICE_ONB.HINT5")
                    .foregroundColor(.green300)
                    .font(light16Font)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, Size.h(32))
                    .padding(.top, Size.h(22))
                
                NavigationLink(isActive: $vc.searchDevice, destination: {
                    SearchDeviceView()
                }) { EmptyView() }.isDetailLink(false)
                
                BlueButtonView(title: "CONFIRM", action: goNext)
                    .padding(.bottom, 20)
//                    .alert(isPresented: $showWarning) {
//                       Alert(title: Text("Error while connecting"),
//                             message: Text("STEP3_1_VIEW.ERROR"),
//                             primaryButton: .cancel(Text("CANCEL".localized())),
//                             secondaryButton: .default(Text("Go to Settings".localized()), action: { goToSettings() } ))
//                   }

            }
            .padding(.horizontal, Size.w(16))
            .padding(.top, Size.isNotch ? 30 : 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationView(back: back, bg: LinearGradient(colors: [.blue800], startPoint: .top, endPoint: .bottom), backButtonColor: .gray100)
            .navigationBarItems(trailing: Button(action: vc.skip) {
                Text("CANCEL")
                    .font(medium16Font)
                    .foregroundColor(.gray100)
            })
        }
        .onAppear {
//            vc.wifiName = ""
            vc.password = ""
//            vc.wifiDropdownOption = nil
            vc.selectedOption = "Select Wi-Fi"
        }
    }

    private func goNext() {
        if bleController.isSwitchedOn {
            vc.searchDevice = true
        } else {
            back()
        }
    }

    private func goToSettings() {
        if let url = URL(string:"App-Prefs:root=Bluetooth") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct Step6View_Previews: PreviewProvider {
    static let onBoardProcess = BLEOnBoardPocess()
    static let vc = ContentViewController()
    static var previews: some View {
        NavigationView {
            Step6View()
                .environmentObject(vc)
        }
    }
}
