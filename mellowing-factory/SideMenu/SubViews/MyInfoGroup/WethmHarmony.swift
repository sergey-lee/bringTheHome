//
//  WethmHarmony.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/30.
//

import SwiftUI
import RevenueCat

struct WethmHarmony: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userManager: UserManager
    
    @State var goToDetails = false
    @State var openInfo = false
    
    var body: some View {
        VStack(spacing: 0) {
//            if userManager.subscription.role == 1 {
                let subscription = userManager.subscription
                if subscription.plan != "Basic" && userManager.subscription.role == 1 {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            Text("SIDE.WH.TITLE")
                                .font(medium16Font)
                                .foregroundColor(.gray800)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, Size.w(31))
                            
                            VStack(spacing: 0) {
                                HStack {
                                    Text("PLAN")
                                        .foregroundColor(.gray500)
                                    Spacer()
                                    Text(subscription.canceled ? "CANCELED" : subscription.plan)
                                        .foregroundColor(.gray400)
                                }
                                .font(regular16Font)
                                .padding(Size.w(20))
                                
                                Divider()
                                
                                HStack {
                                    Text("BILLING")
                                        .foregroundColor(.gray500)
                                    Spacer()
                                    Text(subscription.billing)
                                        .foregroundColor(.gray400)
                                }
                                .font(regular16Font)
                                .padding(Size.w(20))
                                
                                Divider()
                                
                                VStack(alignment: .trailing, spacing: Size.h(15)) {
                                    HStack {
                                        Text("RENEWAL_DETAILS")
                                            .foregroundColor(.gray500)
                                        Spacer()
                                        Text(subscription.canceled ? "EXPIRES_ON" : "AUTO_RENEWS_ON")
                                            .foregroundColor(.gray400)
                                    }
                                    Text(subscription.canceled ? subscription.expirationDate : "\(subscription.expirationDate) for \(subscription.price)")
                                        .foregroundColor(.gray400)
                                }
                                .font(regular16Font)
                                .padding(Size.w(20))
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(Size.w(14))
                            .padding(.horizontal, Size.w(22))
                            .padding(.top, Size.h(16))
                            .padding(.bottom, Size.h(22))
                            
                            Button(action: {
                                guard let url = URL(string: "https://apps.apple.com/account/subscriptions") else { return }
                                UIApplication.shared.open(url, options: [:])
                            }) {
                                HStack {
                                    Image("ic-go-to-settings")
                                    Text(subscription.canceled ? "Renew" : "Cancel")
                                        .foregroundColor(subscription.canceled ? .green500 : .red500)
                                }
                            }.frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.horizontal, Size.w(30))
                                .padding(.bottom, Size.h(22))
                            
                            Text("SIDE.WH.HINT")
                                .foregroundColor(.gray300)
                                .font(regular14Font)
                                .padding(.horizontal, Size.w(31))
                                .padding(.bottom, Size.h(22))
                        }
                        .padding(.top, Size.h(32))
                    }
//                }
            } else {
                SubscriptionsView(goToDetails: $goToDetails, isOpened: .constant(false))
            }
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
        }
            .opacity(userManager.subscription.plan != "Basic" && userManager.subscription.role == 1 ? 0 : 1)
            .disabled(userManager.subscription.plan != "Basic" && userManager.subscription.role == 1)
        )
    }
    
    private func back() {
        if goToDetails {
            withAnimation {
                goToDetails = false
            }
        } else {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct WethmHarmony_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WethmHarmony()
                .navigationView(back: {}, title: "Wethm Harmony")
        }
    }
}
