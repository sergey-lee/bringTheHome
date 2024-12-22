//
//  IntensityStep2.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/22.
//

import SwiftUI

struct IntensityStep2: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var vc: ContentViewController

    @State var nextStep = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("DEVCICE_ONB.TITLE21")
                .font(light18Font)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.1), radius: 10)
                .padding(.bottom, Size.h(47))
            
            Text("DEVCICE_ONB.TEXT10")
                .font(light18Font)
                .foregroundColor(.green100)
                .shadow(color: .black.opacity(0.1), radius: 10)
                .padding(.bottom, Size.h(40))
            
            Text("DEVCICE_ONB.TEXT11")
                .font(light18Font)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.1), radius: 10)
                .padding(.bottom, Size.h(47))
            
            Text("DEVCICE_ONB.TEXT12")
                .font(light18Font)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.1), radius: 10)
            
            Spacer()
            
            NavigationLink(isActive: $nextStep, destination: {
                IntensityStep3()
            }) {
                BlueButtonView(title: "CONFIRM", action: {
                    nextStep = true
                })
            }.isDetailLink(false)
            .padding(.bottom, 20)
        }
        .padding(.horizontal, Size.w(16))
        .padding(.top, Size.isNotch ? 30 : 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationView(back: back, bg: LinearGradient(colors: [.blue800], startPoint: .top, endPoint: .bottom), backButtonColor: .gray100)
        .navigationBarItems(trailing: Button(action: back) {
            Text("CANCEL")
                .font(medium16Font)
                .foregroundColor(.gray100)
        })
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct IntensityStep2_Previews: PreviewProvider {
    static let vc = ContentViewController()
    
    static var previews: some View {
        NavigationView {
            Group {
                IntensityStep2()
                    .environmentObject(vc)
                    .previewDevice("iPhone 11 Pro")
            }
        }
    }
}
