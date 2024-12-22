//
//  ConnectionProblem.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/05/31.
//

import SwiftUI

struct ConnectionIssueView: View {
    enum IssueType {
        case server, bluetooth
    }
    
    @EnvironmentObject var vc: ContentViewController
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var type: IssueType = .server
    
    var body: some View {
        VStack(spacing: Size.h(15)) {
            Image("ic-warning")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red400)
                .frame(width: Size.w(45), height: Size.w(45))
                .padding(2.5)
                .padding(.top, Size.h(54))
            Text(type == .bluetooth ? "DEVCICE_ONB.TITLE11" : "DEVCICE_ONB.TITLE12")
                .font(regular18Font)
                .lineSpacing(7)
                .multilineTextAlignment(.center)
                .foregroundColor(.red400)
            
            Spacer()
            
            Text(type == .bluetooth ? "DEVCICE_ONB.TEXT1" : "DEVCICE_ONB.TEXT2")
                .font(regular18Font)
                .foregroundColor(.white)
                .padding(.horizontal, Size.w(14))
                .lineSpacing(7)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Text("DEVCICE_ONB.HINT8")
                .font(regular16Font)
                .foregroundColor(.gray400)
                .lineSpacing(7)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, Size.w(14))
                .padding(.bottom, Size.h(30))
            NegativeButtonView(title: type == .bluetooth ? "DEVCICE_ONB.TRY" : "CONFIRM", action: {
                if type == .bluetooth {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    vc.step2.toggle()
                }
            })
            .padding(.bottom, 20)
        }.padding(.horizontal, Size.w(16))
         .frame(maxWidth: .infinity, maxHeight: .infinity)
         .navigationView(backButtonHidden: true, bg: LinearGradient(colors: [.blue800], startPoint: .top, endPoint: .bottom))
         .navigationBarItems(trailing: Button(action: vc.skip) {
             Text("SKIP")
                 .font(medium16Font)
                 .foregroundColor(.gray100)
         })
    }
}

struct WrongDataView: View {
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var deviceManager: DeviceManager
    
    let ssid: String
    
    var body: some View {
        VStack(spacing: Size.h(15)) {
            Image("ic-warning")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red400)
                .frame(width: Size.w(40), height: Size.w(40))
                .padding(.top, Size.h(54))
            
            Group {
                Text("DEVCICE_ONB.ERROR1") + Text(ssid)
            }
                .font(regular18Font)
                .lineSpacing(7)
                .multilineTextAlignment(.center)
                .foregroundColor(.red400)
            
            Spacer()
            
            Text("DEVCICE_ONB.TEXT3")
                .font(regular18Font)
                .foregroundColor(.white)
            Spacer()
            Text("DEVCICE_ONB.HINT9")
                .font(regular16Font)
                .foregroundColor(.gray400)
                .lineSpacing(7)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.bottom, Size.h(30))
            NegativeButtonView(title: "DEVCICE_ONB.TRY", action: {
                vc.connecting.toggle()
            })
            .padding(.bottom, 20)
        }.padding(.horizontal, Size.w(16))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationView(backButtonHidden: true, bg: LinearGradient(colors: [.blue800], startPoint: .top, endPoint: .bottom))
    }
}

struct ConnectionIssueView_Previews: PreviewProvider {
    static var previews: some View {
//        Group {
            ConnectionIssueView()
//            WrongDataView(ssid: "mellowing")
                .environmentObject(ContentViewController())
            .previewDevice("iPhone X")
//        }
    }
}
