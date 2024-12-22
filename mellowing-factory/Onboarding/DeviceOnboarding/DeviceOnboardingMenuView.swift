//
//  MenuView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/05/30.
//

import SwiftUI

struct OnboardingProgressView : View {
    var xOffset: CGFloat
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 0) {
                    Circle()
                        .stroke(lineWidth: Size.w(1))
                        .frame(width: Size.w(7), height: Size.w(7))
                    Rectangle()
                        .frame(width: Size.w(18), height: Size.w(1))
                    Circle()
                        .stroke(lineWidth: Size.w(1))
                        .frame(width: Size.w(7), height: Size.w(7))
                    Rectangle()
                        .frame(width: Size.w(18), height: Size.w(1))
                    Circle()
                        .stroke(lineWidth: Size.w(1))
                        .frame(width: Size.w(7), height: Size.w(7))
                    Rectangle()
                        .frame(width: Size.w(18), height: Size.w(1))
                    Circle()
                        .stroke(lineWidth: Size.w(1))
                        .frame(width: Size.w(7), height: Size.w(7))
                }.foregroundColor(.gray600)
                
                HStack(alignment: .center, spacing: 0) {
                    Circle()
                        .fill(Color.mellowingBlueLight)
                        .frame(width: Size.w(7), height: Size.w(7))
                        .overlay(
                            Circle()
                                .fill(Color.mellowingBlue)
                                .frame(width: Size.w(12), height: Size.w(12))
                                .blur(radius: 8)
                        )
                        .offset(x: xOffset)
                }
            }.frame(width: Size.w(82), height: Size.w(7), alignment: .leading)
            Spacer()
        }
        
    }
}
