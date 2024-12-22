//
//  ListSectionView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/26.
//

import SwiftUI

struct ListSectionView: View {
    @Binding var selected: Int
    
    let title: String
    let list: [String]
    
    var body: some View {
        VStack(spacing: 0) {
            ListHeaderView(title: title)
            VStack(spacing: 0) {
                ForEach(0..<list.count, id:\.self) { index in
                    Button(action: {
                        self.selected = index
                    }) {
                        HStack {
                            Text(LocalizedStringKey(list[index]))
                                .font(regular16Font)
                            Spacer()
                            
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: Size.h(14), height: Size.h(14))
                                .opacity(index == self.selected ? 1 : 0)
                        }
                        .foregroundColor(.gray400)
                        .padding(Size.w(20))
                    }
                    Divider().opacity(index + 1 < list.count ? 1 : 0)
                }
            }
            .tableStyle()
        }
    }
}

struct ListHeaderView: View {
    let title: String
    
    var body: some View {
        Text(title.localized())
            .textCase(nil)
            .font(medium16Font)
            .foregroundColor(.gray800)
            .padding(.top, Size.h(32))
            .padding(.bottom, Size.h(16))
            .padding(.horizontal, Size.w(31))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ListHeaderView_Previews: PreviewProvider {
    static let sessionManager = SessionManager()
    static let deviceManager = DeviceManager(username: "sergey@mellowingfactory.com")
    static let userManager = UserManager(username: "sergey@mellowingfactory.com", userId: "1")
    static let msc = MainScreenController()
    
    static var previews: some View {
        NavigationView {
            UnitsSelection()
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


