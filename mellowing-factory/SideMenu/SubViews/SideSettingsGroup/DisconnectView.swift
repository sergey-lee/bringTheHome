//
//  DisconnectView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/23.
//

import SwiftUI

struct DisconnectView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var vc: ContentViewController
    
    @State var isLoading = false
    @State var showWarning = false
    @State var showError = false
    
    var body: some View {
        ZStack {
            Color.blue800.ignoresSafeArea()
            VStack(spacing: Size.h(15)) {
//                ZStack {
////                    BackButton(action: back, color: .white)
////                        .frame(maxWidth: .infinity, alignment: .leading)
//                    Text("CONNECTION_TERMINATION")
//                        .foregroundColor(.white)
//                        .font(semiBold17Font)
//                }
//                .padding(.top)
                
                ScrollView(showsIndicators: false) {
                    Image("ic-warning")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red400)
                        .frame(width: Size.w(40), height: Size.w(40))
                        .padding(.top, Size.h(32))
                    Text("SIDE.SET.DIS.HINT")
                        .font(regular18Font)
                        .lineSpacing(7)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red400)
                        .padding(.bottom, Size.h(17))
                    
                    Text("SIDE.SET.DIS.HINT2")
                        .font(light18Font)
                        .foregroundColor(.white)
                        .lineSpacing(7)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, Size.h(150))
                    //                    Spacer()
                    
                   
                        NegativeButtonView(title: "CONFIRM", action: {
                            showWarning = true
                        })
                        .padding(.bottom, 150)
                        .alert(isPresented: $showWarning) {
                            Alert(title: Text("ALERT.DEVICE.UNREG"),
                                  message: Text(""),
                                  primaryButton: .cancel(Text("CANCEL".localized())),
                                  secondaryButton: .destructive(Text("UNREGISTER".localized())) { deleteDevice() })
                        }
                }
            }.padding(.horizontal, Size.w(16))
            
            if isLoading {
            LoadingBox()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .navigationView(back: back, title: "CONNECTION_TERMINATION", backButtonColor: .white)
        .onChange(of: vc.refreshTodayScreen) { _ in
            back()
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func deleteDevice() {
        isLoading = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            isLoading = false
//        }
        deviceManager.deleteIotDevice() { success in
            vc.skip()
            isLoading = false
            showError = !success
        }
    }
}

struct Disconnect1View_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DisconnectView()
                .environmentObject(DeviceManager(username: ""))
                .environmentObject(ContentViewController())
        }
    }
}
