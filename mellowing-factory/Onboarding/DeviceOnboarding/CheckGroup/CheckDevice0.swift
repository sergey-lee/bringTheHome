//
//  CheckDevice0.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/09/08.
//

import SwiftUI

struct CheckDevice0: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var vc: ContentViewController

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                Text("DEVCICE_ONB.TITLE13.1")
                    .font(light18Font)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 10)
                
                Spacer()
                ZStack {
                    Image("device-power")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        
                    Circle()
                        .fill(Color.green200.opacity(0.7))
                        .frame(width: Size.w(10), height: Size.w(10))
                        .blur(radius: 4)
                        .offset(x: Size.w(-38), y: 3)
                }
                .frame(width: Size.w(375), height: Size.w(340))
                .padding(.horizontal, Size.w(-32))
                
                Text("DEVCICE_ONB.HINT9.1")
                    .foregroundColor(.green300)
                    .font(light16Font)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, Size.h(32))
                    .padding(.top, Size.h(22))
                
                NavigationLink(destination: { CheckDevice() }) {
                    BlueButtonLink(title: "NEXT")
                }
//                NavigationLink(isActive: $vc.searchDevice, destination: {
//                    CheckDevice()
//                }) { EmptyView() }.isDetailLink(false)
//
//                BlueButtonView(title: "CONFIRM", action: {
//                    vc.checkDevice = true
//                })
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
    }

    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct ChechDevice0_Previews: PreviewProvider {
    static let onBoardProcess = BLEOnBoardPocess()
    static let vc = ContentViewController()
    static var previews: some View {
        NavigationView {
            CheckDevice0()
                .environmentObject(vc)
        }
    }
}

