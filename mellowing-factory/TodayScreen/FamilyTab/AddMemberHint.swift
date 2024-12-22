//
//  AddMemberHint.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/14.
//

import SwiftUI

struct AddMemberHint: View {
    @Binding var hintPresented: Bool
    
    let addMember: () -> Void
    
    var body: some View {
        VStack(spacing: Size.h(32)) {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    Image("harmony-add")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Size.w(170), height: Size.w(170))
                        .padding(.bottom, Size.h(-10))
                    Text("TODAY.ADD.TITLE")
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .font(regular17Font)
                        .foregroundColor(.gray700)
                        .padding(.horizontal, Size.w(25))
                        .padding(.bottom, Size.h(16))
                    Text("TODAY.ADD.HINT")
                        .multilineTextAlignment(.center)
                        .font(regular14Font)
                        .foregroundColor(.gray300)
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal, Size.w(22))
                        .padding(.bottom, Size.h(32))
                    
                    Button(action: addMember) {
                        Text("TODAY.ADD_MEMBER")
                            .foregroundColor(.white)
                            .font(semiBold20Font)
                            .padding(.vertical, Size.h(16))
                            .frame(maxWidth: .infinity)
                            .background(gradientPrimaryButton)
                    }
                }
                .overlay(
                    Image("bg-member-details")
                        .resizable()
                        .scaledToFill()
                        .allowsHitTesting(false)
                )
            }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray200.opacity(0.5), radius: 5, y: 5)
                .padding(.horizontal, Size.w(32))
            
            Button(action: {
                withAnimation {
                    Defaults.addUserHintWasShown = true
                    hintPresented = false
                }
            }) {
                Text("CLOSE")
                    .foregroundColor(.gray500)
                    .font(semiBold16Font)
                    .underline()
            }
        }
        .opacity(hintPresented ? 1 : 0)
        .offset(y: hintPresented ? -50 : UIScreen.main.bounds.height)
    }
}

struct AddMemberHint_Previews: PreviewProvider {
    static var previews: some View {
        AddMemberHint(hintPresented: .constant(true), addMember: {})
    }
}
