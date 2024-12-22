//
//  TableModifier.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/27.
//

import SwiftUI

struct TableModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.white)
            .cornerRadius(Size.w(14))
            .padding(.horizontal, Size.w(16))
            .padding(.bottom, Size.h(16))
    }
}


extension View {
    func tableStyle() -> some View {
        modifier(TableModifier())
    }
}
