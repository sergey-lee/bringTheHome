//
//  AvatarLabel.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/30.
//

import SwiftUI

struct AvatarLabel: View {
    let isAdmin: Bool
    let isInGroup: Bool
    
    var body: some View {
        Group {
            if isAdmin || isInGroup {
                HStack {
                    Image("logo-blue")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Size.w(14), height: Size.h(11))
                    Text(isAdmin ? "ADMIN" : "HARMONY")
                        .font(semiBold14Font)
                }
                .foregroundColor(isAdmin ? .blue500 : .green500)
                .padding(Size.h(7))
                .padding(.horizontal, Size.w(4))
                .background(Color.white)
                .cornerRadius(Size.h(20))
                .shadow(color: Color.blue500.opacity(0.1), radius: 3, y: 3)
                .offset(y: Size.h(-15))
            }
        }
    }
}

struct AvatarLabel_Previews: PreviewProvider {
    static var previews: some View {
        AvatarLabel(isAdmin: true, isInGroup: true)
    }
}
