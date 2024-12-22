    //
//  LanguageSelection.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/04.
//

import SwiftUI

struct LanguageSelection: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var vc: ContentViewController
    
    @State var index = 0
    @State var defaultIndex = 0
    @State var isLoading = false

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                if isLoading {
                    LoadingBox()
                } else {
                    ForEach(0..<languageList.count, id: \.self) { index in
                        Button(action: {
                            self.index = index
                        }) {
                            HStack {
                                Text(LocalizedStringKey(languageList[index].lang))
                                    .font(regular16Font)
                                Spacer()
                                
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: Size.h(14), height: Size.h(14))
                                    .opacity(index == self.index ? 1 : 0)
                            }.foregroundColor(.gray400)
                        }
                        .padding(.horizontal, Size.w(20))
                        .padding(.top, Size.h(20))
                        .padding(.bottom, Size.h(22))
                        
                        Divider().opacity(index + 1 < languageList.count ? 1 : 0)
                    }
                }
            }
            .tableStyle()
            .padding(.top, Size.h(30))
            
            Spacer()
        }
        .navigationView(back: back, title: "LANGUAGE", bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
        .navigationBarItems(trailing:
                                Button(action: save) {
            Text("FINISH".localized())
                .font(light14Font)
        }.disabled(defaultIndex == index))
        .onAppear() {
            self.index = Defaults.appLanguage
            self.defaultIndex = Defaults.appLanguage
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func save() {
        self.isLoading = true
        withAnimation {
            sessionManager.appLanguage = self.index //languageList[index].number
            Defaults.appLanguage = self.index //languageList[index].number  //"ko"
//            vc.refresh.toggle()
            sessionManager.getCurrentAuthSession()
            self.isLoading = false
            back()
        }
    }
}

struct LanguageSelection_Previews: PreviewProvider {
    static let sessionManager = SessionManager()
    static let deviceManager = DeviceManager(username: "sergey@mellowingfactory.com")
    static let userManager = UserManager(username: "sergey@mellowingfactory.com", userId: "1")
    static let msc = MainScreenController()
    
    static var previews: some View {
        NavigationView {
            LanguageSelection()
                .environmentObject(sessionManager)
                .environmentObject(deviceManager)
                .environmentObject(userManager)
                .environmentObject(msc)
                .onAppear {
                    userManager.apiNodeUser = ApiNodeUser(id: "lisa", email: "lisa@gmail.com", name: "Lisa", familyName: "Wilson", membership: "basic", fakeLocation: "Dallas, TX")
                }
        }
    }
}
