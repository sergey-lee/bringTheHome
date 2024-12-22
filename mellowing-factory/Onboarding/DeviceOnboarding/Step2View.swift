//
//  Step2View.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/05/31.
//

import SwiftUI

struct Step2View: View {
    @State var nextStep = false
    
    var body: some View {
        ZStack {
            AnimatedBG().ignoresSafeArea()
            
            VStack(alignment: .center, spacing: Size.isNotch ? 20 : 10) {
                VStack(alignment: .leading, spacing: Size.h(16)) {
                    Image("wethm-logo-text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 32)
                    
                    Text("DEVCICE_ONB.TITLE2")
                        .font(light18Font)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 10)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Size.w(8))
                .padding(.top, Size.h(100))
                
                Spacer()
            }.padding(.horizontal, Size.w(22))
        }
        .navigationView(backButtonHidden: true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                nextStep = true
            }
        }
        
        NavigationLink(isActive: $nextStep, destination: {
            Step3View()
        }) { EmptyView() }.isDetailLink(false)
    }
}

struct Step2View_Previews: PreviewProvider {
    static var previews: some View {
//        NavigationView {
            Step2View()
//        }
    }
}
