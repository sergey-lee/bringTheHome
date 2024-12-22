//
//  ScanQRView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/09.
//

import SwiftUI
import Contacts

struct ScanQRView: View {
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var userManager: UserManager
    
    @State var torchIsOn = false
    @State var infoPresented = false
    @State var isGalleryPresented = false
    @State var qrCodeSuccess = false
    @State var contact: QRContact? = nil
    @State var showError = false
    @State var errorMessage = "TODAY.QR_EXP"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    CodeScannerView(codeTypes: [.qr], scanMode: .continuous, isTorchOn: $torchIsOn, isGalleryPresented: $isGalleryPresented, completion: handleScan)
                        
                    VStack {
//                        HStack {
//                            Spacer()
//                            Button(action: {
//                                // FIXME: freeze when torch is on
////                                torchIsOn.toggle()
//                            }) {
//                                Image(torchIsOn ? "ic-torch-on" : "ic-torch-off")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: Size.w(32), height: Size.w(32))
//                            }
//                        }
//                        .padding(Size.w(22))
                        
                        Spacer()
                        Button(action: {
                            isGalleryPresented = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.white)
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.green400.opacity(0.4), lineWidth: 2)
                                HStack {
                                    Image("ic-album")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: Size.w(22), height: Size.w(22))
                                    Text("ALBUM")
                                        .font(semiBold18Font)
                                }
                                .foregroundColor(.green400)
                            }
                            .frame(width: Size.w(140), height: Size.h(44))
                        }
                        .padding(.bottom, Size.h(22))
                    }
                }
                
                Text("TODAY.QR_HINT")
                    .foregroundColor(.gray600)
                    .font(regular16Font)
                    .multilineTextAlignment(.center)
                    .padding(.top, Size.h(32))
                Text("TODAY.QR_HINT2")
                    .foregroundColor(.gray300)
                    .font(regular14Font)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Size.w(30))
                    .padding(.top, Size.h(16))
                    .padding(.bottom, Size.h(18))
                    .padding(.bottom, Size.safeArea().bottom)
                
                NavigationLink(isActive: $qrCodeSuccess, destination: {
                    if let contact {
                        AddMemberView(contact: contact)
                    }
                }) {
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(gradientBackground)
            .navigationView(back: back, title: "TODAY.QR_TITLE")
            .navigationBarItems(trailing: Button(action: {
                infoPresented = true
            }) {
                Image("information")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray800)
                    .frame(width: Size.w(20), height: Size.w(20))
            })
            .sheetWithDetents(isPresented: $infoPresented, onDismiss: {}) {
                ContentInfoSheet(type: .qrcode)
            }
            .onChange(of: contact) { contact in
                if contact != nil {
                    qrCodeSuccess = true
                }
            }
            .onAppear {
                if contact != nil {
                    contact = nil
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text(errorMessage),
                      message: Text(""),
                      dismissButton: .cancel(Text("OK")))
            }
        }
    }
    
    private func back() {
        withAnimation {
            vc.state = .none
        }
    }
    
    func onFoundQrCode(_ code: String) {
        back()
            print(code)
        }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            if let data = result.string.data(using: .utf8) {
                if let contact: QRContact = decodeJson(data: data) {
                    let date = contact.d.convertToDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                    if Date() > date.plusOffset() {
                        print("QR code expired!")
                        errorMessage = "TODAY.QR_EXP"
                        showError = true
                    } else {
                        self.contact = contact
//                        DispatchQueue.main.async {
//                            userManager.addUser(u_id: contact.id)
//                        }
                    }
                    
                    print(contact)
                } else {
                    errorMessage = "TODAY.QR_WRONG"
                    showError = true
                    print("Wrong format")
                }
            }
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

struct ScanQRView_Previews: PreviewProvider {
    static var previews: some View {
        ScanQRView()
    }
}

struct QRContact: Encodable, Decodable, Equatable {
    let id: String
    var n: String? = nil
    var f: String? = nil
    let e: String
    let d: String
}
