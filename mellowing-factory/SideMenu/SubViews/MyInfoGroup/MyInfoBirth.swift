//
//  MyInfoGender.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/29.
//

import SwiftUI
import Amplify

struct MyInfoBirth: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userManager: UserManager
    
    @State var pickedDateOfBirth = 1990
    
    @State var isLoading = false
    @State var isWheelOpened = false

    var body: some View {
        ZStack {
            VStack(spacing: Size.h(22)) {
                Button(action: {
                    withAnimation {
                        isWheelOpened.toggle()
                    }
                }) {
                    HStack {
                        Text(userManager.birthString)
                            .foregroundColor(.gray500)
                            .font(regular18Font)
                        Spacer()
                        Image("chevron-up").rotationEffect(.degrees(180))
                            .foregroundColor(.gray300)
                    }
                    .padding()
                    .padding(.vertical, 5)
                    .background(Color.white)
                    .cornerRadius(14)
                }.padding(.top, Size.h(35))
                
                Text("SIDE.ACC.HINT")
                    .foregroundColor(.gray300)
                    .font(regular14Font)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, Size.w(14))
                
                Spacer()
                
                LineBlueButton(title: "DELETE",  action: {
                    pickedDateOfBirth = 0
                    save()
                }, textColor: Color.green500, borderColor: Color.green400)
                .padding(.bottom, Size.h(20))
            }
            .onAppear {
                setPicker()
            }
            .onChange(of: isWheelOpened) { _ in
                setPicker()
            }
            
            ZStack {
                Color.black.opacity(isWheelOpened ? 0.5 : 0).ignoresSafeArea()
                VStack {
                    Spacer()
                    Color.black.opacity(isWheelOpened ? 0.001 : 0).ignoresSafeArea()
                        .frame(height: UIScreen.main.bounds.height * 0.6)
                        .onTapGesture() {
                            withAnimation {
                                isWheelOpened.toggle()
                            }
                        }
                }
                VStack {
                    Spacer()
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                save()
                            }) {
                                Text("CONFIRM")
                                    .font(semiBold18Font)
                                    .foregroundColor(.blue400)
                            }.padding(Size.h(15))
                        }
                        Picker("", selection: $pickedDateOfBirth) {
                            ForEach(1920...2020, id: \.self) { number in
                                Text(String(number))
                                    .foregroundColor(.black)
                            }
                        }.pickerStyle(WheelPickerStyle())
                        Spacer()
                    }.frame(height: Size.w(250 + 48))
                        .background(Color.gray200)
                        .offset(y: isWheelOpened ? 0 : Size.w(250 + 48))
                }.ignoresSafeArea(.all)
            }.padding(.horizontal, Size.h(-22))
            
            if isLoading {
                LoadingBox()
            }
        }
        .padding(.horizontal, Size.w(22))
        .navigationView(back: back, title: "BIRTH_YEAR", bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
    }

    private func setPicker() {
        if userManager.apiNodeUser.age == nil || userManager.apiNodeUser.age == 0 {
            pickedDateOfBirth = 1990
        } else {
            pickedDateOfBirth = userManager.apiNodeUser.age!
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func save() {
        isLoading = true
        withAnimation {
            isWheelOpened = false
        }
        userManager.updateApiUser(birthYear: pickedDateOfBirth) { result in
            userManager.apiNodeUser.age = pickedDateOfBirth
            userManager.birthString = pickedDateOfBirth == 0 ? "" : String(pickedDateOfBirth)
            isLoading = false
            back()
        }
    }
}

struct MyInfoBirth_Previews: PreviewProvider {
    static let sessionManager = SessionManager()
    static let deviceManager = DeviceManager(username: "sergey@mellowingfactory.com")
    static let userManager = UserManager(username: "sergey@mellowingfactory.com", userId: "1")
    static let msc = MainScreenController()
    
    static var previews: some View {
        NavigationView {
            MyInfoBirth()
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
