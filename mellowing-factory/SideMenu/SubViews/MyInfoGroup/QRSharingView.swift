//
//  QRSharingView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/01.
//

import SwiftUI
import QRCode

struct QRSharingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var vc: ContentViewController
    @Namespace private var animation
    
    
    @State var showShare = false
    @State var isLoading = false
    @State var openInfo = false
    

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text(vc.expired ? "SIDE.QR.EXP" : "SIDE.QR.JOIN")
                    .foregroundColor(.gray1000)
                    .font(semiBold26Font)
                    .multilineTextAlignment(.center)
                    .padding(.top, Size.h(32))
                
                let statusText: LocalizedStringKey = vc.expired ? "SIDE.QR.VALID" : "SIDE.QR.TIMER"
                (Text(statusText) + vc.validTimer.secondsToMinutesSecondsText())
                    .foregroundColor(.gray400)
                    .font(regular18Font)
                    .lineLimit(nil)
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .fixedSize()
                    .padding(.top, Size.h(12))
                    .padding(.bottom, Size.h(40))
                    .opacity(isLoading ? 0.01 : 1)
                
                    ZStack {
                        if isLoading {
                            ProgressView()
                        } else {
                            if let qrcode = vc.qrcode {
                                ZStack {
                                    QRCodeDocumentUIView(document: qrcode)
                                        .blur(radius: vc.expired ? 3 : 0)
                                        .opacity(vc.expired ? 0.4 : 1)
                                    if vc.expired {
                                        Button(action: refresh) {
                                            Image("ic-error-refresh")
                                                .resizable()
                                                .foregroundColor(.white)
                                                .scaledToFit()
                                                .frame(width: Size.w(60), height: Size.w(60))
                                                .padding(10)
                                                .background(Color.green400)
                                                .frame(width: Size.w(80), height: Size.w(80))
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: Size.w(200), height: Size.w(200))
                    .padding(7)
                    .background(Color.white)
                    .cornerRadius(15)
                    .matchedGeometryEffect(id: "middle", in: animation)
                    .padding(.bottom, Size.h(32))

                    Text("SIDE.QR.HINT")
                        .foregroundColor(.gray300)
                        .font(regular14Font)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Size.w(22))
                        .matchedGeometryEffect(id: "semi-bottom", in: animation)
                
                
                Spacer()

                    Button(action: {
                        showShare = true
                    }) {
                        Image("ic-share-button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: Size.w(80), height: Size.w(80))
                            .matchedGeometryEffect(id: "bottom", in: animation)
                    }
                    .disabled(vc.qrImage == nil)
                    .opacity(vc.qrImage == nil ? 0.3 : 1)
                    .blur(radius: vc.expired ? 3 : 0)
                    .opacity(vc.expired ? 0.4 : 1)
                    .disabled(vc.expired)
                    .padding(.bottom, Size.h(20))
                    .sheet(isPresented: $showShare) {
                        if let image = vc.qrImage {
                            ShareSheet(showShare: $showShare, photo: image)
                        }
                    }
                
            }
            .padding(.horizontal, Size.w(16))
            .opacity(showShare ? 0.4 : 1)
            .onChange(of: vc.qrcode) { code in
                if let code {
                    let fullName = (userManager.apiNodeUser.name ?? "") + " " + (userManager.apiNodeUser.familyName ?? "")
                    vc.qrImage = QRCodeCard(username: fullName, qrcode: code).snapshot()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .navigationView(back: back, title: "SHARE_QR")
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
//        .onChange(of: vc.qrImage) { img in
//            if img != nil {
//                vc.startListening(userManager: userManager)
//            }
//        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                initialize()
            }
        }
        .onDisappear {
//            vc.timer?.invalidate()
//            vc.counter?.invalidate()
//            vc.timer = nil
//            vc.counter = nil
        }
    }
    
//    private var adminCard: some View {
//        ZStack(alignment: .bottom) {
//            let current = userManager.listOfUsers.count
//            let subscription = userManager.subscription
//            let isMember = userManager.subscription.role == 0
//
//            Color.white
//                .frame(width: .infinity, height: Size.h(221))
//                .cornerRadius(14)
//                .shadow(color: Color.init(hex: "91ACC5").opacity(0.4), radius: 16, y: 20)
//                .matchedGeometryEffect(id: "middle", in: animation)
//            VStack(spacing: 0) {
//                ZStack {
//                    Image("admin-avatar-frame")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: Size.h(94), height: Size.h(94))
//                    Circle()
//                        .fill(Color.gray50)
//                        .frame(width: Size.h(80), height: Size.h(80))
//                    Text(String(subscription.name?.capitalized.first ?? "A"))
//                        .font(semiBold58Font)
//                        .foregroundColor(.gray700)
//
//                }.frame(width: Size.h(94), height: Size.h(94))
//                    .clipShape(Circle())
//
//                AvatarLabel(isAdmin: true, isInGroup: true)
//
//                Text("\(subscription.plan) Harmony Plan")
//                    .font(regular14Font)
//                    .foregroundColor(.gray400)
//                    .padding(.bottom, Size.h(8))
//                HStack(alignment: .lastTextBaseline) {
//                    Text("\(subscription.name ?? "Admin")'s Harmony")
//                        .tracking(-1)
//                        .font(semiBold24Font)
//                        .foregroundColor(.gray800)
//                }.frame(maxWidth: .infinity)
//                    .padding(.bottom, Size.h(15))
//
//                HStack {
//                    Group {
//
//                        HStack {
//                            Image("logo-blue")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: Size.w(14), height: Size.h(11))
//                            Text(isMember ? "Harmony" : "Admin")
//                                .font(semiBold14Font)
//                        }
//                        .foregroundColor(.gray500)
//                        .padding(Size.w(8))
//                        .padding(.horizontal, Size.w(6))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 30)
//                                .stroke(Color.gray50)
//                        )
//                    }
//
//                    Group {
//                        HStack(spacing: 5) {
//                            Image("ic-person")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: Size.w(10), height: Size.w(11.5))
//
//                            Text("\(current) / \(subscription.maxMembers)")
//                                .tracking(-1)
//                                .font(semiBold14Font)
//                        }
//                        .foregroundColor(current >= Int(subscription.maxMembers) ?? 10 ? .yellow700 : .gray500)
//                        .padding(Size.w(8))
//                        .padding(.horizontal, Size.w(6))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 30)
//                                .stroke(Color.gray50)
//                        )
//                    }
//                }
//            }
//            .padding(.horizontal, Size.w(14))
//            .padding(.bottom, Size.h(40))
//        }
//        .padding(.bottom, Size.h(32))
//    }
    
    private func refresh() {
        guard let email = userManager.apiNodeUser.email else { return }
        guard let id = userManager.apiNodeUser.id else { return }
        self.isLoading = true
        let expirationDate = Date().addingTimeInterval(Double(qrCodeExpTime)).toStringUTC(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        let contact = QRContact(id: id, n: userManager.apiNodeUser.name, f: userManager.apiNodeUser.familyName, e: email, d: expirationDate)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(contact)
            if let json = String(data: jsonData, encoding: String.Encoding.utf8) {
                let qrcodeDoc: QRCode.Document = {
                    let doc = QRCode.Document(generator: QRCodeGenerator_External())
                    doc.utf8String = json
                    doc.design.shape.onPixels = QRCode.PixelShape.Squircle(insetFraction: 0.1)
                    doc.design.shape.eye = QRCode.EyeShape.Squircle()
                    doc.errorCorrection = .high
                    let image = UIImage(named: "wethm-logo-qr")!
                    
                    // Centered square logo
                    doc.logoTemplate = QRCode.LogoTemplate(
                        image: image.cgImage!,
                        path: CGPath(rect: CGRect(x: 0.40, y: 0.40, width: 0.20, height: 0.20), transform: nil),
                        inset: 2
                    )
                    return doc
                }()
                vc.qrcode = qrcodeDoc
                if vc.qrcode != nil {
                    vc.startListening(userManager: userManager)
                }
            }
            withAnimation {
                vc.validTimer = qrCodeExpTime
                vc.expired = false
                isLoading = false
            }
        } catch {
            withAnimation {
                isLoading = false
            }
            print("Error while encoding to json!")
        }
    }
    
    private func initialize() {
        guard vc.timer == nil else { return }
        guard vc.expired != true else { return }
        refresh()
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    
}

struct QRSharingView_Previews: PreviewProvider {
    static let userManager = UserManager(username: "asfsdf", userId: "sdfsdf")
    static let vc = ContentViewController()
    
    static var previews: some View {
        QRSharingView()
            .environmentObject(userManager)
            .environmentObject(vc)
    }
}
