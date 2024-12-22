//
//  SubsFromDetails.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/09.
//

import SwiftUI

struct SubsFromDetails: View {
    @Binding var isOpened: Bool
    @State var goToDetails = false
    @State var openInfo = false
    
    var body: some View {
        ZStack {
            SubscriptionsView(goToDetails: $goToDetails, isOpened: $isOpened)
        }
        .navigationView(back: back, title: goToDetails ? "WETHM_HARMONY" : "", bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
        .navigationBarItems(trailing: Button(action: {
            openInfo = true
        }) {
            Image("information")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray800)
                .frame(width: Size.w(20), height: Size.w(20))
                .disabled(true)
                .opacity(0.5)
        })
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

//struct SubsFromDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        SubsFromDetails()
//    }
//}
