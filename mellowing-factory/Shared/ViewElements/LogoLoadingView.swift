//
//  LogoLoadingView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/03.
//

import SwiftUI

struct LogoLoadingView: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Image("wethm-logo-large")
                    .opacity(0.05)
            }.padding(.bottom, 30)
            
            VStack(spacing: 0) {
                Spacer()
                Image("wethm-logo")
                    .padding(.bottom, 18)
                Image("wethm-logo-text")
                    .foregroundColor(.black)
                    .padding(.bottom, 36)
                Text("@mellowingfactory")
                    .font(regular14Font)
                    .foregroundColor(.gray400)
            }
            
            ProgressView()
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .background(Color.gray10.ignoresSafeArea())
         
    }
}

struct LogoLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LogoLoadingView()
            .previewDevice("iPhone 14 Pro Max")
    }
}

//class SleepInduction {
//    let isOn: Bool
//    let smartAlarm: Bool
//    let ButtonActivation: Bool
//    let strength: Int
//    let frequency: Bool (or 0,1)
//}

