//
//  SideMenuTopView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/28.
//

import SwiftUI

struct SideMenuTopView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var msc: MainScreenController
    
    var body: some View {
        let user = userManager.apiNodeUser
        VStack(spacing: 0) {
            
            let isAdmin = userManager.group?.role == 1
            let isInGroup = userManager.group != nil
            
            AvatarView(size: .medium, user: user, isAdmin: isAdmin)
            AvatarLabel(isAdmin: isAdmin, isInGroup: isInGroup)
            
            HStack(alignment: .lastTextBaseline) {
                Group {
                    if user.name?.detectedLanguage() != "Korean" && user.name?.detectedLanguage() != "Japanese" {
                        Text((user.name ?? "") + " " + (user.familyName ?? ""))
                    } else {
                        Text((user.familyName ?? "") + (user.name ?? ""))
                    }
                }
                    .font(semiBold24Font)
                    .foregroundColor(.gray800)
            }.frame(maxWidth: .infinity)
             .padding(.top, Size.h(isInGroup ? 5 : 16))
             .padding(.bottom, Size.h(6))
            
            if let email = user.email {
                Text(email)
                    .lineLimit(1)
                    .font(regular14Font)
                    .foregroundColor(.gray500)
            }
        }
    }
}
