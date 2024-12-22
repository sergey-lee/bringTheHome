//
//  Step5View.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/25.
//

import SwiftUI

struct Step5View: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var vc: ContentViewController
    
    @State var nextStep = false
    @State var showAlert = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("DEVCICE_ONB.TITLE5")
                .font(light18Font)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.1), radius: 10)
            
            Spacer()
            
            Image("bluetooth-connect")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .padding(.horizontal, Size.w(-16))
                .padding(.bottom, Size.h(23))
            
            Text("DEVCICE_ONB.HINT4")
                .foregroundColor(.green300)
                .font(light16Font)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .padding(.bottom, Size.h(32))
            
            NavigationLink(isActive: $nextStep, destination: {
                Step6View()
            }) {
                BlueButtonView(title: "NEXT", action: {
                    self.nextStep = true
                })
            }
            .isDetailLink(false)
            .padding(.bottom, 20)
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

struct Step5View_Previews: PreviewProvider {
    static let onBoardProcess = BLEOnBoardPocess()
    static let vc = ContentViewController()
    static var previews: some View {
        NavigationView {
            Step5View()
                .environmentObject(vc)
        }
    }
}
