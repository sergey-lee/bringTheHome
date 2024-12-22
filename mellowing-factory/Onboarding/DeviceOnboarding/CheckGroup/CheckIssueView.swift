//
//  CheckIssue.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/01/26.
//

import SwiftUI

struct CheckIssueView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var vc: ContentViewController

    var body: some View {
        VStack(spacing: Size.h(15)) {
            Image("ic-warning")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red400)
                .frame(width: Size.w(45), height: Size.w(45))
                .padding(2.5)
                .padding(.top, Size.h(54))
            Text("DEVCICE_ONB.TITLE17")
                .font(regular18Font)
                .lineSpacing(7)
                .multilineTextAlignment(.center)
                .foregroundColor(.red400)
                .padding(.horizontal, Size.w(14))
            
            Spacer()
            
            Text("DEVCICE_ONB.TEXT6")
                .multilineTextAlignment(.center)
                .lineSpacing(7)
                .font(regular18Font)
                .padding(.horizontal, Size.w(14))
                .foregroundColor(.white)
            Spacer()
            Spacer()
            NegativeButtonView(title: "CONFIRM", action: back)
            .padding(.bottom, 20)
        }.padding(.horizontal, Size.w(16))
         .frame(maxWidth: .infinity, maxHeight: .infinity)
         .navigationView(backButtonHidden: true, bg: LinearGradient(colors: [.blue800], startPoint: .top, endPoint: .bottom))
    }
    
    private func back() {
        DispatchQueue.main.async {
//            presentationMode.wrappedValue.dismiss()
            vc.startChecking = false
            vc.checkDevice = false
        }
    }
}

struct CheckIssueView_Previews: PreviewProvider {
    static let onboardingProcess = BLEOnBoardPocess()
    static let vc = ContentViewController()
    
    static var previews: some View {
        Group {
            CheckIssueView()
                .environmentObject(vc)
                .environmentObject(onboardingProcess)
                .previewDevice("iPhone 11 Pro")
        }
    }
}
