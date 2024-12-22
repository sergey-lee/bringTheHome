//
//  CheckDevice.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/01/26.
//

import SwiftUI

struct CheckDevice: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var vc: ContentViewController
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Group {
                Text("DEVCICE_ONB.TITLE14")
                    .foregroundColor(.white)
                + Text("START")
                    .foregroundColor(.green100)
                + Text("DEVCICE_ONB.TITLE15")
                    .foregroundColor(.white)
            }
                .font(light18Font)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .shadow(color: .black.opacity(0.1), radius: 10)
            
            Spacer()
            Image("check-device-image")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .padding(.horizontal, Size.w(-32))
            
            Spacer()
            Text("DEVCICE_ONB.HINT10")
                .foregroundColor(.green300)
                .font(light16Font)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .padding(.bottom, Size.h(32))
            
            
            BlueButtonView(title: "START", action: {
                vc.startChecking = true
            })
            .padding(.bottom, 20)
            
            NavigationLink(isActive: $vc.startChecking, destination: {
                CheckingProcessView()
            }) {
                EmptyView()
            }.isDetailLink(false)
                
        }
        .padding(.horizontal, Size.w(16))
        .padding(.top, Size.isNotch ? 30 : 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationView(back: back, bg: LinearGradient(colors: [.blue800], startPoint: .top, endPoint: .bottom), backButtonColor: .gray100)
        .navigationBarItems(trailing: Button(action: skip) {
            Text("CANCEL")
                .font(medium16Font)
                .foregroundColor(.gray100)
        })
    }
    
    private func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func skip() {
        withAnimation {
            vc.checkDevice = false
        }
    }
}

struct CheckDevice_Previews: PreviewProvider {
    static let vc = ContentViewController()

    static var previews: some View {
        NavigationView {
            Group {
                CheckDevice()
                    .environmentObject(vc)
                    .previewDevice("iPhone 11 Pro")
                    .environment(\.locale, .init(identifier: "ja"))
            }
            
        }
    }
}
