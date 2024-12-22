//
//  UserOnboardingView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/09.
//

import SwiftUI

struct UserOnboarding: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var userManager: UserManager
    @AppStorage("weightUnit") var weightUnit = Defaults.weightUnit
    @AppStorage("heightUnit") var heightUnit = Defaults.heightUnit
    
    @State var birthYear = -1
    @State var gender = -1
    @State var weightOptions = [-1,0]
    @State var weight = -1
    @State var heightOptions = [-1,0]
    @State var height = -1
    @State var isLoading = false
    @State var activeDropdownState: DropdownState = .none
    
    @State var isYearPickerActive = false
    @State var isGenderPickerActive = false
    @State var isWeightPickerActive = false
    @State var isHeightPickerActive = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                VStack(alignment: .center, spacing: Size.h(16)) {
                    Image("wethm-logo-both")
                        .frame(width: Size.w(150), height: Size.h(80))
                    Text("SLOGAN")
                        .font(medium16Font)
                        .gradientForeground(colors: [.green100, .blue500])
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, Size.h(55))
                .padding(.bottom, Size.h(65))
                .background(InductionBackground(sleepInductionStarted: .constant(true), maxHeight: 450).ignoresSafeArea())
                
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.top, Size.h(-40))
            
            SheetForm(isKeyboardOpened: .constant(false), content: {
                ZStack {
//                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: Size.h(16)) {
                            
                            Text("USER_ONB.HINT")
                                .tracking(-0.5)
                                .font(regular14Font)
                                .foregroundColor(.gray300)
                                .padding(.bottom, Size.h(16))
                                .padding(.horizontal, Size.w(14))
                            
                            DropdownPicker(isActive: $isYearPickerActive, selectedOption: $birthYear, state: .birthYear, placeholder: "BIRTH_YEAR")
                                .padding(.horizontal, Size.w(6))
                            
                            DropdownPicker(isActive: $isGenderPickerActive, selectedOption: $gender, state: .gender, placeholder: "GENDER")
                                .padding(.horizontal, Size.w(6))
                            
                            HStack(spacing: 17) {
                                CustomDropdownPicker(isActive: $isWeightPickerActive, options: $weightOptions, value: $weight, state: .weight)
                                CustomDropdownPicker(isActive: $isHeightPickerActive, options: $heightOptions, value: $height, state: .height)
                            }.padding(.horizontal, Size.w(6))
                            
                            Text("USER_ONB.DESC")
                                .tracking(-0.5)
                                .font(regular14Font)
                                .foregroundColor(.gray300)
                                .padding(.horizontal, Size.w(14))
//                                .padding(.bottom, Size.h(34))
                            
                            Spacer()
                            
                            PrimaryButtonView(title: "START", action: save)
                                .disabled(isLoading || isFormEmpty())
                                .opacity(isLoading || isFormEmpty() ? 0.5 : 1)

                        }
//                    }
                    if isLoading {
                        LoadingBox()
                    }
                }
                
            })
            
            WheelPicker(isWheelOpened: $isYearPickerActive,
                        option: $birthYear, innerOption: birthYear,
                        list: getBirthYearOptionsInt(),
                        category: .year)
            WheelPicker(isWheelOpened: $isGenderPickerActive,
                        option: $gender,
                        innerOption: gender,
                        list: getGenderOptionsInt(),
                        category: .gender)
//            if isWeightPickerActive {
                CustomWheelPicker(isWheelOpened: $isWeightPickerActive,
                                  value: $weight,
                                  selections: $weightOptions,
                                  list: getWeightRange(state: .weight),
                                  state: .weight)
//            }
//            if isHeightPickerActive {
                CustomWheelPicker(isWheelOpened: $isHeightPickerActive,
                                  value: $height,
                                  selections: $heightOptions,
                                  list: getWeightRange(state: .height),
                                  state: .height)
//            }
        }
        .navigationView(backButtonHidden: true)
        .navigationBarItems(trailing: Button(action: save) {
            Text("SKIP")
                .font(medium16Font)
                .foregroundColor(.gray100)
        })
    }
    
    private func isFormEmpty() -> Bool {
//        return birthYear == -1 && gender == -1 && height == -1
        return birthYear == -1 && gender == -1 && weight == -1 && height == -1
    }
    
    private func save() {
        isLoading = true
        userManager.updateApiUser(gender: gender < 0 ? nil : gender,
                                  weight: weight < 0 ? nil : weight,
                                  height: height < 0 ? nil : height,
                                  birthYear: birthYear < 0 ? nil : birthYear
        ) { success in
            if success != nil {
                if weightOptions.count > 1 {
                    weightUnit = weightOptions[1] == 0 ? 1 : 0
                }
                if heightOptions.count > 1 {
                    heightUnit = heightOptions[1] == 0 ? 1 : 0
                }
                
                DispatchQueue.main.async {
                    sessionManager.isUserOnboardingCompleted = true
//                    Defaults.isUserOnboardingCompleted = true
                    sessionManager.getCurrentAuthSession()
                    userManager.getUserData()
                    isLoading = false
                }
            } else {
                sessionManager.error = .generalError
            }
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func getWeightRange(state: DropdownState) -> [Double] {
        var min = 30
        var max = 200
        
        if state == .height {
            min = 100
            max = 250
        }
        
        return (min..<max).map { Double($0)  }
    }
}

struct UserOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserOnboarding()
                .environmentObject(SessionManager())
                .environmentObject(UserManager(username: "sergser", userId: "edfgsger"))
        }
    }
}
