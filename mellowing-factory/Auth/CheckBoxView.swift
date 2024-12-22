//
//  CheckBoxView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/05/25.
//

import SwiftUI

struct CheckBoxView: View {
    @Binding var checked: Bool
    
    let title: LocalizedStringKey
    var description: LocalizedStringKey? = nil
    var isButtonEnabled = true
    var titleColor = Color.gray500
    var spacing: CGFloat = 13
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline, spacing: Size.w(spacing)) {
                Button(action: {
                    self.checked.toggle()
                }) {
                    HStack(alignment: .top) {
                        Image(checked ? "checkbox-on" : "checkbox-off")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22)
                        Text(title)
                            .tracking(-1)
                            .font(regular16Font)
                            .foregroundColor(titleColor)
                            .multilineTextAlignment(.leading)
                    }
                }
                if isButtonEnabled {
                    Spacer()
                    Button(action: action ?? {}) {
                        Text("SHOW")
                            .foregroundColor(.gray200)
                            .font(light12Font)
                    }
                }
            }
            if description != nil {
                Text(description!)
                    .font(light14Font)
                    .foregroundColor(.gray600)
                    .tracking(-0.5)
                    .padding(.leading, Size.w(30))
            }
        }
    }
}
