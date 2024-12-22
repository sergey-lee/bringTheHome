//
//  SecondaryButtonView.swift
//  mellowing-factory
//
//  Created by Florian Topf on 22.01.22.
//

import SwiftUI

struct SecondaryButtonView: View {
    var title: LocalizedStringKey
    let action: () -> Void
    var underlined: Bool = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(light12Font)
                .foregroundColor(.gray500)
                .underline(underlined)
        }.frame(height: Size.w(12))
    }
}

struct SecondaryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButtonView(title: "SIGNIN.SIGNUP", action: {})
        .preferredColorScheme(.dark)
        .previewDevice("iPhone 11 Pro")
    }
}
