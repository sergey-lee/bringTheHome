//
//  SubsFromMembers.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/14.
//

import SwiftUI

struct SubsFromMembers: View {
    @Binding var isOpened: Bool
    @State var goToDetails = false
    @State var openInfo = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    BackButton(action: back)
                    Spacer()
                    Button(action: {
                        openInfo = true
                    }) {
                        Image("information")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray800)
                            .frame(width: Size.w(20), height: Size.w(20))
                    }
                    .disabled(true)
                    .opacity(0.5)
                }
                if goToDetails {
                    HStack {
                        Spacer()
                        Text("WETHM_HARMONY")
                            .font(semiBold17Font)
                            .foregroundColor(.gray700)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, Size.w(22))
            .padding(.bottom, Size.h(16))
            .padding(.top, Size.h(13))
            SubscriptionsView(goToDetails: $goToDetails, isOpened: $isOpened)
        }
    }
    
    private func back() {
        withAnimation {
            if goToDetails {
                goToDetails = false
            } else {
                isOpened = false
            }
        }
    }
}

struct SubsFromMembers_Previews: PreviewProvider {
    static var previews: some View {
        SubsFromMembers(isOpened: .constant(true))
    }
}
