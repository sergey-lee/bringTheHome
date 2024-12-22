//
//  LineBlueButton.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/17.
//

import SwiftUI

struct LineGreenButton: View {
    var title: LocalizedStringKey
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title)
                    .font(medium18Font)
                    .foregroundColor(.green500)
                    .padding(.vertical, Size.h(15.5))
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.green400, lineWidth: 1)
            )
            .padding(.horizontal, 1)
        }
    }
}

struct LineBlueButton: View {
    var title: LocalizedStringKey
    let action: () -> Void
    var textColor: Color = Color.blue100
    var borderColor: Color = Color.blue200
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title)
                    .font(medium18Font)
                    .foregroundColor(textColor)
                    .padding(.vertical, Size.h(15.5))
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            )
            .padding(.horizontal, 1)
        }
    }
}

struct LineBlueButtonLink: View {
    var title: LocalizedStringKey

    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(medium18Font)
                .foregroundColor(.blue100)
                .padding(.vertical, Size.h(15.5))
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue200, lineWidth: 1)
        )
        .padding(.horizontal, 1)
    }
}
