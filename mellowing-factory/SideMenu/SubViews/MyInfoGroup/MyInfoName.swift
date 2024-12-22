//
//  MyInfoName.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/29.
//

import SwiftUI
import Amplify

struct MyInfoName: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var vc: ContentViewController
    
    @State var name = ""
    @State var familyName = ""
    
    @State var isLoading = false
    @State var isButtonEnabled = false
    
    var body: some View {
        let isSame = familyName == userManager.apiNodeUser.familyName && name == userManager.apiNodeUser.name || name.isEmpty || familyName.isEmpty
        
        ZStack {
            VStack(spacing: Size.h(22)) {
                VStack {
                    AccountTextInputView(title: "SURNAME",
                                         placeholder: "SURNAME",
                                         text: $familyName,
                                         keyboardType: .default,
                                         textType: .name)
                    .padding()
                    Divider()
                    AccountTextInputView(title: "NAME",
                                         placeholder: "NAME",
                                         text: $name,
                                         keyboardType: .default,
                                         textType: .name)
                    .padding()
                }
                
                .background(Color.white)
                .cornerRadius(14)
                
                Text("SIDE.ACC.NAME")
                    .foregroundColor(.gray300)
                    .multilineTextAlignment(.leading)
                    .font(regular14Font)
                    .padding(.horizontal, Size.w(14))
                
                Spacer()
            }
            .padding(.top, Size.h(32))
            .frame(maxHeight: .infinity)
            
            if isLoading {
                LoadingBox()
            }
        }
        .padding(.horizontal, Size.w(16))
        .frame(maxHeight: .infinity)
        .navigationView(back: back, title: "NAME", bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
        .navigationBarItems(trailing:
                                Button(action: save) {
            Text("SAVE")
                .font(medium16Font)
                .foregroundColor(.blue400)
                .opacity(isSame ? 0.5 : 1)
        }.disabled(isSame)
        )
        .onAppear {
            self.name = userManager.apiNodeUser.name ?? ""
            self.familyName = userManager.apiNodeUser.familyName ?? ""
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func save() {
        isLoading = true
        sessionManager.updateAttributes(name: name, familyName: familyName)
        userManager.updateApiUser(name: name, familyName: familyName) { user in
            vc.refresh.toggle()
            isLoading = false
            back()
        }
    }
}

struct MyInfoName_Previews: PreviewProvider {
    static let sessionManager = SessionManager()
    static let deviceManager = DeviceManager(username: "sergey@mellowingfactory.com")
    static let userManager = UserManager(username: "sergey@mellowingfactory.com", userId: "1")
    static let msc = MainScreenController()
    
    static var previews: some View {
        NavigationView {
            VStack {
                MyInfoName()
                    .environmentObject(sessionManager)
                    .environmentObject(deviceManager)
                    .environmentObject(userManager)
                    .environmentObject(msc)
                    .onAppear {
                        userManager.apiNodeUser = ApiNodeUser(id: "lisa", email: "lisa@gmail.com", name: "Lisa", familyName: "Wilson", membership: "basic", fakeLocation: "Dallas, TX")
                    }
            }
            .frame(maxHeight: .infinity)
        }
        
        
    }
}
