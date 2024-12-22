//
//  WarningButton.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/14.
//

import SwiftUI

struct WarningButton: View {
    var title: LocalizedStringKey
    let action: () -> Void
    var isDisabled: Bool = false
    
    var body: some View {
        if !isDisabled {
            Button(action: action) {
                Text(title)
                    .font(regular16Font)
                    .foregroundColor(Color("warning"))
                    .padding(.vertical, Size.h(15.5))
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(LinearGradient(colors: [Color(red: 160/255, green: 105/255, blue: 231/255, opacity: 0.15), Color(red: 160/255, green: 105/255, blue: 231/255, opacity: 0.09), Color(red: 160/255, green: 105/255, blue: 231/255, opacity: 0.12)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(colors: [Color(red: 160/255, green: 105/255, blue: 231/255, opacity: 0.15), Color(red: 160/255, green: 105/255, blue: 231/255, opacity: 0.09), Color(red: 160/255, green: 105/255, blue: 231/255, opacity: 0.15),], startPoint: .topLeading, endPoint: .bottomTrailing)))
                            .frame(maxWidth: .infinity)
                    )
            }
        } else {
            Button(action: action) {
                Text(title)
                    .font(regular16Font)
                    .foregroundColor(Color.white).opacity(0.1)
                    .padding(.vertical, Size.h(15.5))
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray10))
            }
        }
    }
}
