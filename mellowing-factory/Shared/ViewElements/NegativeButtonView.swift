//
//  NegativeButton.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/05/30.
//

import SwiftUI

struct NegativeButtonView: View {
    var title: LocalizedStringKey
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(medium18Font)
                .foregroundColor(.white)
                .padding(.vertical, Size.h(16))
                .frame(maxWidth: .infinity)
                .background(Color.red400)
                .cornerRadius(Size.w(10))
        }
    }
}

struct NegativeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NegativeButtonView(title: "Suboptimal", action: {})
    }
}
