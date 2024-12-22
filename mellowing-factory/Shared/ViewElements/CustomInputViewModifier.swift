//
//  CustomInputViewModifier.swift
//  mellowing-factory
//
//  Created by Florian Topf on 23.12.21.
//

import SwiftUI

struct CustomInputViewModifier: ViewModifier {
    var color: Color = .gray800
    var background = Color.clear
    var corners: UIRectCorner = .allCorners
    var height: CGFloat = 54
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .frame(height: height)
            .background(background)
            .cornerRadius(10, corners: corners)
            .foregroundColor(.red)
            .font(light30Font)
            .overlay(
                RoundedCorner(radius: 10, corners: corners)
                    .stroke(color, lineWidth: 1)
            )
    }
}

struct DropDownModifier: ViewModifier {
    var values: Int
    
    func body(content: Content) -> some View {
        content
            .frame(height: Size.w(CGFloat(54 * values)))
//            .frame(maxHeight: Size.h(320))
            .background(Color.blue800)
            .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
            .overlay(
                RoundedCorner(radius: 8, corners: [.bottomRight, .bottomLeft])
                    .stroke(Color.blue400, lineWidth: 1)
            )
    }
}
