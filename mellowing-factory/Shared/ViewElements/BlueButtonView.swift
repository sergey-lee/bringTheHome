//
//  BlueButtonView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/05/25.
//

import SwiftUI

struct BlueButtonView: View {
    var title: LocalizedStringKey
    let action: () -> Void
    var disabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(medium18Font)
                .foregroundColor(.white)
                .padding(.vertical, Size.h(16))
                .frame(maxWidth: .infinity)
                .background(Color.green400.opacity(disabled ? 0.2 : 1))
                .cornerRadius(Size.w(10))
        }
        .disabled(disabled)
    }
}

struct BlueButtonLink: View {
    var title: LocalizedStringKey
    
    var body: some View {
        Text(title)
            .font(medium18Font)
            .foregroundColor(.white)
            .padding(.vertical, Size.h(16))
            .frame(maxWidth: .infinity)
            .background(Color.green400)
            .cornerRadius(Size.w(10))
    }
}
