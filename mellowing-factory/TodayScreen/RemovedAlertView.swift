//
//  RemovedAlertView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/20.
//

import SwiftUI

struct RemovedAlertView: View {
    @Binding var showRemovedAlert: Bool

    var body: some View {
        VStack(spacing: Size.h(32)) {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    let adminName = Defaults.adminName?.components(separatedBy: "...")[0] ?? "Admin"
                    Image("harmony-delete")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Size.w(120), height: Size.w(120))
                        .padding(.bottom, Size.h(22))
                        .padding(.top, Size.h(32))
                    Group {
                        Text("TODAY.REMOVED1") + Text("**\(adminName)**") + Text("TODAY.REMOVED2")
                    }
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .font(regular17Font)
                        .foregroundColor(.gray700)
                        .padding(.horizontal, Size.w(25))
                        .padding(.bottom, Size.h(16))
                    
                    Text("TODAY.HINT1")
                        .multilineTextAlignment(.center)
                        .font(regular14Font)
                        .foregroundColor(.gray300)
                        .padding(.horizontal, Size.w(22))
                        .padding(.bottom, Size.h(32))
                        .fixedSize(horizontal: false, vertical: true)
                    Button(action: {
                        withAnimation {
                            Defaults.adminName = nil
                            showRemovedAlert = false
                        }
                    }) {
                        Text("CONFIRM")
                            .foregroundColor(.white)
                            .font(semiBold20Font)
                            .padding(.vertical, Size.h(16))
                            .frame(maxWidth: .infinity)
                            .background(Color.green400)
                    }
                }
            }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray200.opacity(0.5), radius: 5, y: 5)
                .padding(.horizontal, Size.w(32))
        }
        .opacity(showRemovedAlert ? 1 : 0)
        .offset(y: showRemovedAlert ? -50 : UIScreen.main.bounds.height)
    }
}

struct RemovedAlertView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RemovedAlertView(showRemovedAlert: .constant(true))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
