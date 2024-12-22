//
//  AdminPanel.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/09/14.
//

import SwiftUI

struct AdminPanel: View {
    @AppStorage("isAppOnboarded") var isAppOnboarded = Defaults.isOnboarded
    
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var deviceManager: DeviceManager
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                PrimaryButtonView(title: "Go To App Onboarding", action: {
                    isAppOnboarded = false
                    sessionManager.getCurrentAuthSession()
                })
                
//                PrimaryButtonView(title: "Reset Coaching Marks", action: {
//                    for i in 0...4 {
//                        UserDefaults.standard.set(false, forKey: "coaching-\(i)")
//                    }
//                    back()
//                    DispatchQueue.main.async {
//                        vc.state = .coachMain
//                    }
//                })
                
                PrimaryButtonView(title: "Reset User Defaults", action: {
                    clearUserDefaults()
                })
                
                //                    Toggle(isOn: $sessionManager.isDummyData, label: { Text("Dummy Data").font(light14Font) })
                
                NavigationLink(("Local Files >>")) {
                    ListOfLocalDocs()
                }
                
//                NavigationLink(("Subscriptions Page >>")) {
//                    SubscriptionsView(navigation: navigation, goToDetails: <#Binding<Bool>#>)
//                }
                
//                let newValue = userManager.apiNodeUser.membership == "free" ? "premium" : "free"
//                
//                PrimaryButtonView(title: "Switch to: **\(newValue)**", action: {
//                    userManager.updateApiUser(membership: newValue) { _ in
////                        userManager.dummySubscription()
//                    }
//                })
                
//                PrimaryButtonView(title: "Delete Device", action: deleteDevice)
                
            }.padding(.horizontal, Size.h(22))
             .padding(.top, Size.safeArea().top)
        }.navigationView(back: back, title: "Admin Panel")
    }

//    private func deleteDevice() {
//        if deviceManager.connectedDevice != nil {
//            deviceManager.deleteIotDevice(deviceId: deviceManager.connectedDevice!.id) { result in
//                switch result {
//                case true:
//                    DispatchQueue.main.async {
//                        deviceManager.connectedDevice = nil
//                        deviceManager.isOnboarded = false
//                    }
//                case false:
//                    print("false to delete IOT device")
//                }
//            }
//        } else {
//            deviceManager.deviceStatus = .noDevice
//        }
//    }
    
    private func back() {
        vc.navigation = nil
    }
    
    func clearUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
//        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
}

struct ListOfLocalDocs: View {
    @State var realmList: [URL] = []
    
    var body: some View {
        VStack {
            Button(action: { deleteRealmFiles() }) {
                Text("Delete Realm")
            }
            List() {
                Text("Sounds:")
                ForEach(getDocumentDirectory(), id: \.self) { doc in
                    Text(doc.absoluteString)
                        .font(.caption2)
                }
                Text("Realm:")
                ForEach(realmList, id: \.self) { doc in
                    Text(doc.absoluteString)
                        .font(.caption2)
                }
            }
        }.onAppear {
            realmList = getRealmDocs()
        }
        
    }
    
    func deleteRealmFiles() {
        deleteFiles(urlsToDelete: getRealmDocs())
        realmList = getRealmDocs()
    }
}

