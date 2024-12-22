//
//  TransparentButton.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/09/07.
//

import SwiftUI

struct TransparentButton: View {
    var title: LocalizedStringKey
    let action: () -> Void
    var color = Color.white
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(regular16Font)
                .foregroundColor(color.opacity(0.7))
                .padding(.vertical, Size.h(15.5))
                .frame(height: Size.h(59))
                .frame(maxWidth: .infinity)
                .background(Blur(style: .systemUltraThinMaterialLight, intensity: 0.2))
                .cornerRadius(Size.w(14))
                .overlay(
                    RoundedRectangle(cornerRadius: Size.w(14))
                        .stroke(LinearGradient(colors: [Color(red: 222 / 255, green: 242 / 255, blue: 241 / 255).opacity(0.05),
                                                        Color(red: 96 / 255, green: 188 / 255, blue: 235 / 255).opacity(0.03)], startPoint: .top, endPoint: .bottom), lineWidth: Size.w(1))
                )
        }
    }
}
