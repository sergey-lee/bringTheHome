//
//  JoinSuccessView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/13.
//

import SwiftUI

struct JoinSuccessView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var vc: ContentViewController

    @State var confettiCounter = 0
    @State var isLoading = false
    @State var goToSuccessView = false
    
    var body: some View {
        ZStack {
            ConfettiBackView(confettiCounter: $confettiCounter)

            VStack(spacing: 0) {
                Text("CONGRATULATIONS")
                    .foregroundColor(.gray1000)
                    .font(semiBold26Font)
                    .multilineTextAlignment(.center)
                    .padding(.top, Size.h(32))
                Text("SIDE.ACC.JOIN_SUCCESS")
                    .foregroundColor(.gray400)
                    .font(regular18Font)
                    .multilineTextAlignment(.center)
                    .padding(.top, Size.h(12))
                    .padding(.bottom, Size.h(40))

                ZStack(alignment: .bottom) {
                    let current = userManager.listOfUsers.count
                    let subscription = userManager.subscription

                    Color.white
                        .frame(width: .infinity, height: Size.h(221))
                        .cornerRadius(14)
                        .shadow(color: Color.init(hex: "91ACC5").opacity(0.4), radius: 16, y: 20)
                    VStack(spacing: 0) {
                        ZStack {
                            Image("admin-avatar-frame")
                                .resizable()
                                .scaledToFit()
                                .frame(width: Size.h(94), height: Size.h(94))
                            Circle()
                                .fill(Color.gray50)
                                .frame(width: Size.h(80), height: Size.h(80))
                            Text(String(subscription.name?.capitalized.first ?? "A"))
                                .font(semiBold58Font)
                                .foregroundColor(.gray700)

                        }.frame(width: Size.h(94), height: Size.h(94))
                            .clipShape(Circle())

                        AvatarLabel(isAdmin: true, isInGroup: true)

                        Text("\(subscription.plan) Harmony Plan")
                            .font(regular14Font)
                            .foregroundColor(.gray400)
                            .padding(.bottom, Size.h(8))
                        HStack(alignment: .lastTextBaseline) {
                            Text("SIDE.ACC.ADMIN \(subscription.name ?? "Admin")")
                                .tracking(-1)
                                .font(semiBold24Font)
                                .foregroundColor(.gray800)
                        }.frame(maxWidth: .infinity)
                            .padding(.bottom, Size.h(15))

                        HStack {
                            Group {

                                HStack {
                                    Image("logo-blue")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: Size.w(14), height: Size.h(11))
                                    Text("Admin")
                                        .font(semiBold14Font)
                                }
                                .foregroundColor(.gray500)
                                .padding(Size.w(8))
                                .padding(.horizontal, Size.w(6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.gray50)
                                )
                            }

                            Group {
                                HStack(spacing: 5) {
                                    Image("ic-person")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: Size.w(10), height: Size.w(11.5))

                                    Text("\(current) / \(subscription.maxMembers)")
                                        .tracking(-1)
                                        .font(semiBold14Font)
                                }
                                .foregroundColor(current >= Int(subscription.maxMembers) ?? 10 ? .yellow700 : .gray500)
                                .padding(Size.w(8))
                                .padding(.horizontal, Size.w(6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.gray50)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, Size.w(14))
                    .padding(.bottom, Size.h(40))
                }
                .padding(.bottom, Size.h(32))
                .padding(.horizontal, Size.w(14))

                Button(action: {
                    withAnimation {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            vc.selectedIndex = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            vc.selectedTab = 1
                        }
                    }
                }) {
                    Text("VIEW")
                        .foregroundColor(.gray500)
                        .font(semiBold16Font)
                        .underline()
                }

                Spacer()

                PrimaryButtonView(title: "DONE", action: dismiss)
                .padding(.bottom, Size.h(40))
            }
            .padding(.horizontal, Size.w(16))
            .padding(.top, Size.h(80))

            ConfettiFrontView(confettiCounter: $confettiCounter)

        }
        .background(gradientBackground.ignoresSafeArea())
        .onAppear {
            let repetitionInterval: Double = 3.5
            Timer.scheduledTimer(withTimeInterval: repetitionInterval, repeats: true) { _ in
                confettiCounter += 1
            }.fire()
        }
    }

    private func dismiss() {
        withAnimation {
            vc.state = .none
        }
    }
}

struct JoinSuccessView_Previews: PreviewProvider {
    static let userManager = UserManager(username: "", userId: "")
    static var previews: some View {
        JoinSuccessView()
            .environmentObject(userManager)
    }
}

