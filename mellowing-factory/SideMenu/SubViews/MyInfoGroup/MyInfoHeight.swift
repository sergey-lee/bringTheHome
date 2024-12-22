//
//  MyInfoGender.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/29.
//

import SwiftUI
import Amplify

struct MyInfoHeight: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userManager: UserManager
    
    @State var isLoading = false
    @State var isWheelOpened = false
    @State var pickedHeight = 170
    @State var feet: Int = 5
    @State var inches: Int = 6
    
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
                            Text(userManager.heightString)
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
                        pickedHeight = 0
                        feet = 0
                        save()
                    }, textColor: Color.green500, borderColor: Color.green400)
//                    .padding(.bottom, Size.safeArea().bottom)
                    .padding(.bottom, Size.h(20))
                }
            }
            .onAppear() {
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
                            Button(action: save) {
                                Text("CONFIRM")
                                    .font(semiBold18Font)
                                    .foregroundColor(.blue400)
                            }.padding(Size.h(15))
                        }
                        if Defaults.heightUnit == 0 {
                            Picker("", selection: $pickedHeight) {
                                ForEach(100...240, id: \.self) { number in
                                    Text("\(number)cm")
                                        .foregroundColor(.black)
                                }
                            }.pickerStyle(.wheel)
                        } else {
                            Section {
                                GeometryReader { geometry in
                                    HStack(spacing: 0) {
                                        Picker("", selection: $feet) {
                                            ForEach(1...7, id: \.self) { number in
                                                if number == 1 {
                                                    Text("\(number) foot")
                                                        .foregroundColor(.black)
                                                } else {
                                                    Text("\(number) feet")
                                                        .foregroundColor(.black)
                                                }
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                        .frame(width: geometry.size.width * 0.5)
                                        .clipped()
                                        
                                        Picker("", selection: $inches) {
                                            ForEach(1...11, id: \.self) { number in
                                                if number == 1 {
                                                    Text("\(number) inch")
                                                        .foregroundColor(.black)
                                                } else {
                                                    Text("\(number) inches")
                                                        .foregroundColor(.black)
                                                }
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                        .frame(width: geometry.size.width * 0.5)
                                        .clipped()
                                    }
                                }
                            }
                            
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
            .navigationView(back: back, title: "HEIGHT", bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
    }
    
    private func setPicker() {
        if userManager.apiNodeUser.height == nil || userManager.apiNodeUser.height == 0 {
            pickedHeight = 170
            feet = Int(Double(170) / 30.48)
            inches = Int(Double(170) / 2.54 - Double(Int(feet) * 12))
        } else {
            pickedHeight = userManager.apiNodeUser.height!
            feet = Int(Double(userManager.apiNodeUser.height!) / 30.48)
            inches = Int(Double(userManager.apiNodeUser.height!) / 2.54 - Double(Int(feet) * 12))
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
        if Defaults.heightUnit == 1 {
            pickedHeight = Int(Double(feet) * 30.48 + Double(inches + 1) * 2.54)
        }
        userManager.updateApiUser(height: pickedHeight) { result in
            userManager.apiNodeUser.height = pickedHeight
            isLoading = false   
            back()
        }
    }
}

