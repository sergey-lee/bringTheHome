//
//  WheelPicker.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/12.
//

import SwiftUI

struct WheelPicker: View {
    enum wheelCategory {
        case gender, weight, height, year
    }
    
    @Binding var isWheelOpened: Bool
    @Binding var option: Int
    
    @State var innerOption: Int
    
    var list: [Int]
    var category: wheelCategory
    let genders = ["MALE", "FEMALE", "OTHER"]
    
    var body: some View {
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
                            innerOption == -1 ? (option = list[0]) : (option = innerOption)
                            withAnimation {
                                isWheelOpened.toggle()
                            }
                        }) {
                            Text("CONFIRM")
                                .font(semiBold18Font)
                                .foregroundColor(.blue400)
                        }.padding(Size.h(15))
                    }
                    Picker("", selection: $innerOption) {
                        ForEach(list, id: \.self) {
                            if category == .gender {
                                if $0 < 3 {
                                    Text(genders[$0].localized())
                                        .foregroundColor(.black)
                                }
                            } else {
                                Text(String($0)).foregroundColor(.black)
                            }
                        }
                    }.pickerStyle(WheelPickerStyle())
                    Spacer()
                }.frame(height: Size.w(250 + 48))
                 .background(Color.gray50)
                 .offset(y: isWheelOpened ? 0 : Size.w(250 + 48))
            }.ignoresSafeArea(.all)
        }
    }
}

