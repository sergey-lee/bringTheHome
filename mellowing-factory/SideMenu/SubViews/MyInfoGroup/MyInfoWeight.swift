//
//  MyInfoGender.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/29.
//

import SwiftUI
import Amplify

struct MyInfoWeight: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userManager: UserManager
    
    @State var pickedWeight = 40
    @State var isLoading = false
    @State var isWheelOpened = false
    
    var body: some View {
        ZStack {
            ZStack {
                VStack(spacing: Size.h(20)) {
                    Button(action: {
                        withAnimation {
                            isWheelOpened.toggle()
                        }
                    }) {
                        HStack {
                            Text(userManager.weightString)
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
                    
                    LineBlueButton(title: "DELETE", action: {
                        pickedWeight = 0
                        userManager.weightString = ""
                        save()
                    }, textColor: Color.green500, borderColor: Color.green400)
                    .padding(.bottom, Size.safeArea().bottom)
                    .padding(.bottom, Size.h(20))
                    
                }.disabled(isLoading)
                 .opacity(isLoading ? 0.3 : 1)
            }
            .onAppear {
                setPicker()
            }
            .onChange(of: isWheelOpened) { bool in
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
                        if Defaults.weightUnit == 0 {
                            Picker("", selection: $pickedWeight) {
                                ForEach(20...150, id: \.self) { number in
                                    Text("\(number)kg")
                                        .foregroundColor(.black)
                                }
                            }.pickerStyle(WheelPickerStyle())
                        } else {
                            Picker("", selection: $pickedWeight) {
                                ForEach(20...150, id: \.self) { number in
                                    Text("\(Int(Double(number) * 2.205))lb")
                                        .foregroundColor(.black)
                                }
                            }.pickerStyle(WheelPickerStyle())
                        }
                        Spacer()
                    }.frame(height: Size.w(250 + 48))
                     .background(Color.gray200)
                     .offset(y: isWheelOpened ? 0 : Size.w(250 + 48))
                    
                }.ignoresSafeArea(.all)
            }.padding(.horizontal, Size.h(-22))
            
            if isLoading {
                LoadingBox()
            }
        }.padding(.horizontal, Size.w(22))
            .navigationView(back: back, title: "WEIGHT", bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
    }
    
    private func setPicker() {
        if userManager.apiNodeUser.weight == nil || userManager.apiNodeUser.weight == 0 {
            pickedWeight = 40
        } else {
            pickedWeight = userManager.apiNodeUser.weight!
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
        userManager.updateApiUser(weight: pickedWeight) { result in
            userManager.apiNodeUser.weight = pickedWeight
            isLoading = false
            back()
        }
    }
}
