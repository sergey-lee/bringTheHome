//
//  DeviceInformation.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/22.
//

import SwiftUI

struct DeviceInformation: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var vc: ContentViewController
    
    @State var animation = false
    @State var isLoading = false
    @State var showWarning = false
    @State var check = false
    
    var body: some View {
        let disconnected = deviceManager.deviceStatus != .disconnected
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Text("SLEEP_ENHANCER")
                    .font(medium16Font)
                    .foregroundColor(.gray800)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Size.w(30))
                    .padding(.bottom, Size.h(16))
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 5) {
                        Image("ic-bluetooth-frame")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                        Text(Defaults.iPhoneName)
                    }
                    if let wifi = Defaults.wifiName {
                        HStack(spacing: 5) {
                            Image("ic-wifi")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                            Text(wifi)
                        }
                    }
                }
                .foregroundColor(.gray400)
                .font(regular12Font)
                .padding(.horizontal, Size.w(30))
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ZStack {
//                    Button(action: {
//                        print("Problem button pressed")
//                    }) {
//                        HStack(alignment: .center, spacing: 5) {
//                            Text("PROBLEM")
//                            Image(systemName: "exclamationmark.circle")
//                        }
//                        .font(medium16Font)
//                        .foregroundColor(.red400)
//                        .padding(.leading, 16)
//                        .padding(.trailing, 32)
//                        .padding(.vertical, 8)
//                        .frame(width: Size.w(disconnected ? 260 : 154), alignment: .leading)
//                        .background(Color.red50)
//                        .cornerRadius(100)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 100)
//                                .inset(by: 0.5)
//                                .stroke(Color.red100, lineWidth: 1)
//                                .frame(width: Size.w(disconnected ? 260 : 154), alignment: .leading)
//                        )
//                    }
                    
                    ZStack {
                        Image("device")
                            .resizable()
                            .scaledToFit()
                        Circle()
                            .fill(disconnected ? Color.blue300 : Color.green200)
                            .frame(width: Size.w(10), height: Size.w(10))
                            .blur(radius: 3.5)
                            .offset(x: Size.w(-34), y: 3)
                            .opacity(animation ? 0 : 1)
                    }
                    .frame(width: Size.w(154), height: Size.w(311), alignment: .center)
                    .frame(width: Size.w(disconnected ? 260 : 154), alignment: .trailing)
                    .onTapGesture {
                        if let email = userManager.apiNodeUser.email {
                            if email.contains("joon") {
                                check = true
                            }
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
                                self.animation = true
                            }
                        }
                    }
                    
                    NavigationLink(isActive: $check, destination: {
                        BioTestView()
                    }) {
                        EmptyView()
                    }
                }
                .padding(.horizontal, Size.w(14))
                
                if let device = deviceManager.connectedDevice {
                    VStack(spacing: 0) {
                        ListRow(name: "DEVICE_NAME", title: "WETHM-SE-1001", arrowIsOn: false)
                            .padding(.top, Size.w(2))
                        
                        Divider()
                        
                        ListRow(name: "SERIAL_NUMBER", title: device.id, arrowIsOn: false)
                        
                        Divider()
                        
                        ListRow(name: "CONNECTION_DATE", title: device.created?.convertToDateString(format: "MMM dd, YYYY") ?? "", arrowIsOn: false)
                            .padding(.bottom, Size.w(2))
                    }
                    .tableStyle()
                }
                
                VStack(spacing: 0) {
                    Button(action: {
                        showWarning = true
                    }) {
                        if isLoading {
                            ProgressView()
                                .foregroundColor(.white)
                                .padding()
                        } else {
                            ListRow(name: "UPDATE_WIFI_C", noTitle: true)
                                .padding(.top, Size.w(2))
                                .alert(isPresented: $showWarning) {
                                    Alert(title: Text("ALERT.DEVICE.UNREG"),
                                          message: Text(""),
                                          primaryButton: .cancel(Text("CANCEL".localized())),
                                          secondaryButton: .destructive(Text("UNREGISTER")) { deleteDevice() })
                                }
                        }
                    }
                    
                    Divider()
                    
                    NavigationLink(destination: { DisconnectView() }) {
                        ListRow(name: "CONNECTION_TERMINATION", noTitle: true)
                    }.isDetailLink(false)
                        .padding(.bottom, Size.w(2))
                }
                .tableStyle()
                .padding(.bottom, Size.h(150))
            }
            .padding(.top, Size.h(32))
        }
        .navigationView(back: back, title: "DEVICE_INFORMATION", bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
        .onChange(of: vc.refreshTodayScreen) { _ in
            back()
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func deleteDevice() {
        isLoading = true
        deviceManager.deleteIotDevice() { success in
            vc.skip()
            isLoading = false
        }
    }
}

struct DeviceInformation_Previews: PreviewProvider {
    static var previews: some View {
        DeviceInformation()
            .environmentObject(DeviceManager(username: "sergey"))
            .environmentObject(UserManager(username: "sergey", userId: ""))
            .environmentObject(ContentViewController())
            .environment(\.locale, .init(identifier: "ja"))
    }
}
