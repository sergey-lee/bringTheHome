//
//  MyInfoGender.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/29.
//

import SwiftUI
import Amplify

struct MyInfoGender: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userManager: UserManager
    
    @State var isLoading = false
    @State var selected = 3
    @State var firstSelected = 3
    @State var isButtonEnabled = false
    
    let genders: [String?] = ["MALE", "FEMALE", "OTHER", ""]
    
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .center, spacing: 0) {
                    ForEach(0..<3, id: \.self) { index in
                        Button(action: {
                            selected = index
                            save()
                        }) {
                            if genders[index] != nil {
                                HStack {
                                    Text(LocalizedStringKey(genders[index]!))
                                        .font(regular16Font)
                                        .foregroundColor(.gray500)
                                    Spacer()
                                    Image("ic-checkmark")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray300)
                                        .frame(width: Size.w(18), height: Size.w(18))
                                        .opacity(selected == index ? 1 : 0)
                                }
                                .padding(.vertical, Size.h(20))
                                .padding(.horizontal, Size.h(24))
                            }
                        }
                        
                        if index != 2 {
                            Divider()
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(Size.w(14))
                .padding(.top, Size.h(22))
                .padding(.bottom, Size.h(12))
                
                Text("SIDE.ACC.HINT")
                    .foregroundColor(.gray300)
                    .font(regular14Font)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, Size.w(14))
                
                Spacer()
                LineBlueButton(title: "DELETE", action: {
                    selected = 3
                    save()
                }, textColor: Color.green500, borderColor: Color.green400)
                .padding(.bottom, Size.w(20))
//                .padding(.bottom, Size.safeArea().bottom)
            }
            
            if isLoading {
                LoadingBox()
            }
        }
        .padding(.horizontal, Size.w(16))
        .navigationView(back: back, title: "GENDER", bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
//        .navigationBarItems(trailing:
//                                Button(action: save) {
//            Text("FINISH")
//                .font(light14Font)
//        }.disabled(selected == firstSelected))
        .onAppear {
            if let gender = userManager.apiNodeUser.gender {
                selected = genders.firstIndex(of: gender) ?? 0
                firstSelected = genders.firstIndex(of: gender) ?? 0
            }
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func save() {
        isLoading = true
        userManager.updateApiUser(gender: selected) { result in
            userManager.apiNodeUser.gender = genders[selected]
            firstSelected = selected
            isLoading = false
            back()
        }
    }
}

struct MyInfoGender_Previews: PreviewProvider {
    static let sessionManager = SessionManager()
    static let deviceManager = DeviceManager(username: "sergey@mellowingfactory.com")
    static let userManager = UserManager(username: "sergey@mellowingfactory.com", userId: "1")
    static let msc = MainScreenController()
    
    static var previews: some View {
        NavigationView {
            MyInfoGender()
                .environmentObject(sessionManager)
                .environmentObject(deviceManager)
                .environmentObject(userManager)
                .environmentObject(msc)
                .onAppear {
                    userManager.apiNodeUser = ApiNodeUser(id: "lisa", email: "lisa@gmail.com", name: "Lisa", familyName: "Wilson", membership: "basic", fakeLocation: "Dallas, TX")
                }
        }
    }
}
