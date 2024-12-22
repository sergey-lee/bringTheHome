//
//  FeedbackView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/08/23.
//

import SwiftUI
import Amplify

struct FeedbackView: View {
    @Binding var isOpened: Bool
    @State var selected = 0
    
    let list: [LocalizedStringKey] = ["FEEDBACK.SELECT0", "FEEDBACK.SELECT1", "FEEDBACK.SELECT2", "FEEDBACK.SELECT3", "FEEDBACK.SELECT4", "FEEDBACK.SELECT5"]
    
    var body: some View {
        VStack(spacing: Size.h(15)) {
            ZStack {
                HStack(alignment: .center, spacing: Size.h(10)) {
                    Button(action: {
                        withAnimation {
                            isOpened.toggle()
                        }
                    }) {
                        Text("CANCEL")
                            .foregroundColor(.gray1100)
                            .font(light14Font)
                    }
                    Spacer()
                }.frame(height: Size.statusBarHeight)
                HStack {
                    Spacer()
                    Text("FEEDBACK.TITLE")
                        .font(regular16Font)
                        .foregroundColor(.gray1100)
                    Spacer()
                }
            }.frame(height: Size.statusBarHeight)
                .padding(.top, Size.w(10))
                .padding(.bottom, Size.w(3))
            
            Text("FEEDBACK.SUBTITLE")
                .foregroundColor(.gray700)
                .lineSpacing(7)
                .multilineTextAlignment(.center)
                .font(light14Font)
                .padding(.bottom, Size.h(35))
            
            Text(list[selected])
                .foregroundColor(.gray1100)
                .font(thin18Font)
                .padding(.bottom, Size.h(5))
            
            RatingView(selected: $selected)
                .padding(.bottom, Size.h(45))
            
            Divider()
                .foregroundColor(.gray200)
            
            Text("FEEDBACK.DESC")
                .foregroundColor(.gray700)
                .tracking(-1)
                .lineSpacing(7)
                .font(light14Font)
                .padding(.horizontal, Size.h(10))
            Spacer()
            PrimaryButtonView(title: "Save", action: {
//                print("rating: \(selected) sended from \(String(describing: Amplify.Auth.getCurrentUser().username))")
                isOpened.toggle()
            }, isDisabled: selected == 0, bg: .gray900, color: .black)
                .disabled(selected == 0)
                .padding(.bottom, Size.h(32))
        }.padding(.horizontal, Size.h(22))
            .padding(.top, Size.h(5))
            .background(gradientBackground.ignoresSafeArea(.all))
    }
}

struct RatingView: View {
    @Binding var selected: Int
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(1..<6) {index in
                Button(action: {
                    selected = index
                }) {
                    Text(String(index))
                        .foregroundColor(.gray200)
                        .font(light22Font)
                        .frame(width: Size.w(54), height: Size.w(50), alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(selected == index ? Color.gray700 : Color.gray800))
                }
                if index != 5 { Spacer() }
            }
            
        }.padding(.horizontal, Size.h(10))
    }
}
