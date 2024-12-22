//
//  PrimaryButtonView.swift
//  mellowing-factory
//
//  Created by Florian Topf on 26.12.21.
//

import SwiftUI

struct PrimaryButtonView: View {
    var title: LocalizedStringKey
    let action: () -> Void
    var isDisabled: Bool = false
    var bg = Color("mellowing-blue-accent")
    var color = Color.white
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(medium18Font)
                .foregroundColor(color)
                .padding(.vertical, Size.h(16))
                .frame(maxWidth: .infinity)
                .background(gradientPrimaryButton.opacity(isDisabled ? 0.3 : 1))
                .cornerRadius(10)
                
        }
    }
}

struct PrimaryButtonLink: View {
    var title: LocalizedStringKey
    var isDisabled: Bool = false
    var bg = Color("mellowing-blue-accent")
    var color = Color.white
    
    var body: some View {
        Text(title)
            .font(medium18Font)
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .frame(height: Size.h(53))
            .background(gradientPrimaryButton.opacity(isDisabled ? 0.3 : 1))
            .cornerRadius(10)
    }
}
