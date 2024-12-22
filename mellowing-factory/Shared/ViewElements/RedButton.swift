//
//  RedButton.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/03.
//

import SwiftUI

struct RedButton: View {
    var title: LocalizedStringKey
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(medium16Font)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: Size.h(39))
                .background(Color.red500)
                .cornerRadius(20)
                .shadow(color: .red500.opacity(0.3), radius: 8, y: 6)
        }
    }
}

struct RedButton_Previews: PreviewProvider {
    static var previews: some View {
        RedButton(title: "Suboptimal", action: {})
    }
}
