//
//  GeneralErrorView.swift
//  mellowing-factory
//
//  Created by Florian Topf on 14.01.22.
//

import SwiftUI

struct GeneralErrorView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ScrollView(showsIndicators: false) {
//                PullToRefresh(coordinateSpaceName: "pullToRefresh", offset: UIScreen.main.bounds.height * 0.3) {
//                    action()
//                }
                VStack(alignment: .center, spacing: 0) {
                    Image("sign-warning")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Size.w(64), height: Size.h(64), alignment: .center)
                    Text("GENERAL_ERROR.TITLE")
                        .font(thin18Font)
                        .foregroundColor(.gray1100)
                        .multilineTextAlignment(.center)
                        .lineSpacing(7)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Button(action: sessionManager.signOut) {
                        Text("SIGNOUT")
                    }
                    .padding()
                    
                }.frame(height: UIScreen.main.bounds.height * 0.8)
            }.frame(height: UIScreen.main.bounds.height * 0.8)
             .coordinateSpace(name: "pullToRefresh")
        }
    }
}
