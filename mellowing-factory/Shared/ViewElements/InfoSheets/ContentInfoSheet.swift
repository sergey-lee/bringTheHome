//
//  ContentInfoSheet.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/08/09.
//

import SwiftUI

enum infoType: String {
    case attributes, harmony, qrcode, radar, stages, vital, env, alarm, suggestions
}

struct ContentInfoSheet: View {
    let type: infoType
    
    let lineSpacing = Size.w(7)
    let textSpacing = Size.w(18)
    
    var body: some View {
        let title: String = "INFO.\(type.rawValue).TITLE"
        let text: String = "INFO.\(type.rawValue).TEXT"
        
        VStack(alignment: .center, spacing: Size.w(22)) {
            Text(LocalizedStringKey(title))
                .font(semiBold17Font)
                .padding(.top, Size.w(22))
            Divider()
                .opacity(0.5)
                .padding(.bottom, Size.h(12))
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(LocalizedStringKey(text))
                        .lineSpacing(lineSpacing)
                        .padding(.bottom, textSpacing)
                        .layoutPriority(1)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .font(regular15Font)
                .padding(.horizontal, Size.w(22))
                Spacer()
            }
        }
        .foregroundColor(.gray600)
        .frame(minHeight: UIScreen.main.bounds.height * 0.5, maxHeight: UIScreen.main.bounds.height, alignment: .top)
//            .background(Color(red: 233/255, green: 233/255, blue: 233/255).edgesIgnoringSafeArea(.all))
        .environment(\.locale, .init(identifier: languageList[Defaults.appLanguage].loc))
            
    }
}

struct AttributesInfoSheet_Previews: PreviewProvider {
    static var previews: some View {
        ContentInfoSheet(type: .attributes)
    }
}
