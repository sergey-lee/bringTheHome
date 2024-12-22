//
//  LimitMembersView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/14.
//

import SwiftUI

struct LimitMembersView: View {
    @Binding var limitExceededPresented: Bool
    
    @State var subsPresented = false
    
    var body: some View {
        VStack(spacing: Size.h(32)) {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    Image("harmony-upgrade")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Size.w(170), height: Size.w(170))
                    Text("TODAY.LIMIT.TITLE")
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .font(regular17Font)
                        .foregroundColor(.gray700)
                        .padding(.horizontal, Size.w(25))
                        .padding(.bottom, Size.h(32))
                    
                    Button(action: {
                        withAnimation {
                            subsPresented = true
                        }
                    }) {
                        Text("SUBSCRIBE")
                            .foregroundColor(.white)
                            .font(semiBold20Font)
                            .padding(.vertical, Size.h(16))
                            .frame(maxWidth: .infinity)
                            .background(gradientPrimaryButton)
                    }
                }
                .overlay(
                    Image("bg-limit-members")
                        .resizable()
                        .scaledToFill()
                        .allowsHitTesting(false)
                )
            }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray200.opacity(0.5), radius: 3)
                .padding(.horizontal, Size.w(32))
                .sheet(isPresented: $subsPresented) {
                    SubsFromMembers(isOpened: $subsPresented)
                }
            
            Button(action: {
                withAnimation {
                    limitExceededPresented = false
                }
            }) {
                Text("BACK")
                    .foregroundColor(.gray500)
                    .font(semiBold16Font)
                    .underline()
            }
        }
        .opacity(limitExceededPresented ? 1 : 0)
        .offset(y: limitExceededPresented ? 0 : UIScreen.main.bounds.height)
    }
}


struct LimitMembersView_Previews: PreviewProvider {
    static var previews: some View {
        LimitMembersView(limitExceededPresented: .constant(true))
    }
}
