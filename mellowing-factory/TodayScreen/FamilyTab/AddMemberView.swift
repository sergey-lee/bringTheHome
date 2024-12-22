//
//  AddMemberView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/12.
//

import SwiftUI

struct AddMemberView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var userManager: UserManager
    @State var isLoading = false
    @State var success = false
    @State var confettiCounter = 0
    
    let contact: QRContact
    
    var body: some View {
        ZStack {
            ConfettiBackView(confettiCounter: $confettiCounter)
            
            VStack(spacing: 0) {
                Text(success ? "CONGRATULATIONS" : "TODAY.ADD.Q")
                    .foregroundColor(.gray1000)
                    .font(semiBold26Font)
                    .multilineTextAlignment(.center)
                    .padding(.top, Size.h(32))
                let prefix = success ? "TODAY.ADD.SUCESS_HINT" : ""
                Group {
                    Text(prefix) + Text("(\(userManager.listOfUsers.count)/\(userManager.subscription.maxMembers)") + Text("TODAY.ADD.SUCESS_REMAIN")
                }
                    .foregroundColor(.gray400)
                    .font(regular18Font)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .padding(.top, Size.h(12))
                    .padding(.bottom, Size.h(40))
                
                ZStack(alignment: .bottom) {
                    Color.white
                        .frame(width: .infinity, height: Size.h(success ? 170 : 155))
                        .cornerRadius(14)
                        .shadow(color: Color.init(hex: "91ACC5").opacity(0.4), radius: 16, y: 20)
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                            Circle()
                                .stroke(Color.gray100, lineWidth: 5)
                            Circle()
                                .fill(Color.gray50)
                                .frame(width: Size.h(80), height: Size.h(80))
                            Text(String(contact.n?.capitalized.first ?? "?"))
                                .font(semiBold58Font)
                                .foregroundColor(.gray700)
                            
                        }.frame(width: Size.h(94), height: Size.h(94))
                            .clipShape(Circle())
                        
                        if success {
                            AvatarLabel(isAdmin: false, isInGroup: true)
                        }
                        
                        HStack(alignment: .lastTextBaseline) {
                            Text((contact.n ?? "") + " " + (contact.f ?? ""))
                                .tracking(-1)
                                .font(semiBold24Font)
                                .foregroundColor(.gray800)
                        }.frame(maxWidth: .infinity)
                            .padding(.top, Size.h(success ? 0 : 16))
                            .padding(.bottom, Size.h(6))
                        Text(contact.e)
                            .lineLimit(1)
                            .font(regular14Font)
                            .foregroundColor(.gray500)
                    }
                    .padding(.horizontal, Size.w(14))
                    .padding(.bottom, Size.h(40))
                }
                .padding(.bottom, Size.h(32))
                .padding(.horizontal, Size.w(14))
                if success {
                    if userManager.subscription.plan != "Basic" {
                        Button(action: {
                            withAnimation {
                                vc.state = .none
                            }
                        }) {
                            Text("VIEW")
                                .foregroundColor(.gray500)
                                .font(semiBold16Font)
                                .underline()
                        }
                    }
                } else {
                    Text("TODAY.ADD.VIEW.HINT")
                        .foregroundColor(.gray300)
                        .font(regular14Font)
                        .padding(.horizontal, Size.w(14))
                }
                
                Spacer()
                
                if success {
                    PrimaryButtonView(title: "DONE", action: {
                        withAnimation {
                            vc.state = .none
                        }
                    })
                    .padding(.bottom, Size.h(20))
                    .onAppear {
                        let repetitionInterval: Double = 3.5
                        Timer.scheduledTimer(withTimeInterval: repetitionInterval, repeats: true) { _ in
                            confettiCounter += 1
                            }.fire()
                    }
                } else {
                    LineBlueButton(title: "CANCEL", action: back, textColor: Color.green500, borderColor: Color.green400)
                        .padding(.bottom, Size.h(20))
                    BlueButtonView(title: "ADD", action: {
                        self.isLoading = true
                        userManager.addUser(u_id: contact.id) { success in
                            withAnimation(.interpolatingSpring(stiffness: 200, damping: 20)) {
                                self.isLoading = false
                                self.success = success
                            }
                        }
                    })
                    .padding(.bottom, Size.h(20))
                }
            }
            .padding(.horizontal, Size.w(16))
            .disabled(isLoading)
            .blur(radius: isLoading ? 3 : 0)
            
            ConfettiFrontView(confettiCounter: $confettiCounter)
            
            if isLoading {
                LoadingBox()
            }
        }
        .navigationView(back: back, title: "TODAY.ADD_MEMBER", backButtonHidden: success)
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddMemberView_Previews: PreviewProvider {
    static var previews: some View {
        AddMemberView(contact: QRContact(id: "sad", n: "Sergey", f: "Lee", e: "sergey@mellowingfactory.com", d: "2023-06-12T02:55:00.594Z"))
            .environmentObject(UserManager(username: "", userId: ""))
            .environmentObject(ContentViewController())
    }
}
