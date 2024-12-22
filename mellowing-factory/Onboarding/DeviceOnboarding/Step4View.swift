//
//  Step4View.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/05/31.
//

import SwiftUI

struct Step4View: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var vc: ContentViewController
    
    @State var nextStep = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("DEVCICE_ONB.TITLE4")
                .tracking(-0.5)
                .font(light18Font)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.1), radius: 10)
            
            Spacer()
            Image("device-on-bed")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .padding(.horizontal, Size.w(-16))
                .padding(.bottom, Size.h(23))
            
            Text("DEVCICE_ONB.HINT3")
                .foregroundColor(.green300)
                .font(light16Font)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Size.h(14))
                .padding(.bottom, Size.h(32))
            
            NavigationLink(isActive: $nextStep, destination: {
                Step5View()
            }) {
                BlueButtonView(title: "NEXT", action: {
                    nextStep = true
                })
            }.isDetailLink(false)
                .padding(.bottom, Size.h(20))
        }
        .padding(.horizontal, Size.w(16))
        .padding(.top, Size.isNotch ? 30 : 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationView(back: back, bg: LinearGradient(colors: [.blue800], startPoint: .top, endPoint: .bottom), backButtonColor: .gray100)
        .navigationBarItems(trailing: Button(action: vc.skip) {
            Text("CANCEL")
                .font(medium16Font)
                .foregroundColor(.gray100)
        })
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct Step4View_Previews: PreviewProvider {
    static let onBoardProcess = BLEOnBoardPocess()
    static let vc = ContentViewController()
    static var previews: some View {
        NavigationView {
            Step4View()
                .environmentObject(vc)
        }
    }
}
