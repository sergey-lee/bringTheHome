//
//  Step3View.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/05/31.
//

import SwiftUI

struct Step3View: View {
    @EnvironmentObject var vc: ContentViewController

    @State var nextStep = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("DEVCICE_ONB.TITLE3")
                .tracking(-0.7)
                .font(light18Font)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.1), radius: 10)
            
            Spacer()
            Image("device-connect")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .padding(.horizontal, Size.w(-16))
                .padding(.bottom, Size.h(23))
            
            Text("DEVCICE_ONB.HINT2")
                .foregroundColor(.green300)
                .font(regular16Font)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .padding(.bottom, Size.h(32))
            
            NavigationLink(isActive: $nextStep, destination: {
                Step4View()
            }) {
                BlueButtonView(title: "NEXT", action: {
                    nextStep = true
                })
            }
            .isDetailLink(false)
            .padding(.bottom, Size.h(20))
        }
        .padding(.horizontal, Size.w(16))
        .padding(.top, Size.isNotch ? 30 : 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationView(back: vc.skip, bg: LinearGradient(colors: [.blue800], startPoint: .top, endPoint: .bottom), backButtonColor: .gray100)
        .navigationBarItems(trailing: Button(action: vc.skip) {
            Text("CANCEL")
                .font(medium16Font)
                .foregroundColor(.gray100)
        })
    }
}

struct Step3View_Previews: PreviewProvider {
    static let onBoardProcess = BLEOnBoardPocess()
    static let vc = ContentViewController()
    static var previews: some View {
        NavigationView {
            Step3View()
                .environmentObject(vc)
        }
    }
}
