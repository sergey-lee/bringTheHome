//
//  PrivacyView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/07.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Image("terms-line")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                VStack(alignment: .leading, spacing: 0) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray50, lineWidth: 1)
                        Image("wethm-logo")
                            .resizable()
                            .scaledToFit()
                            .padding(Size.w(10))
                    }
                    .frame(width: Size.w(64), height: Size.w(64))
                    .padding(.top, Size.h(40))
                    .padding(.bottom, Size.h(30))
                    
                    Text("Wethm Privacy Policy")
                        .font(semiBold32Font)
                        .foregroundColor(.gray1100)
                        .padding(.bottom, Size.h(10))

                    TextBlock(text: "PRIVACY_POLICY.TEXT\(0)")
                    ForEach(1..<14, id: \.self) { index in
                        TextTitle(text: "PRIVACY_POLICY.TITLE\(index)")
                        TextBlock(text: "PRIVACY_POLICY.TEXT\(index)")
                    }
                    
                    Spacer()
                        .frame(height: Size.h(117))
                }.padding(.horizontal, Size.w(30))
                 
            }
            .background(Color.white)
            .padding(.top, Size.h(32))
        }
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PrivacyView()
        }
    }
}

struct TextTitle: View {
    var text: String
    var body: some View {
        Text(LocalizedStringKey(text))
            .tracking(-1)
            .foregroundColor(.gray900)
            .lineSpacing(7)
            .font(semiBold20Font)
            .padding(.top, Size.h(40))
            
    }
}

struct TextBlock: View {
    var text: String
    var body: some View {
        Text(LocalizedStringKey(text))
            .tracking(-0.5)
            .foregroundColor(.gray800)
            .font(regular16Font)
            .lineSpacing(Size.w(8))
            .padding(.top, Size.h(20))
    }
}

//struct TextSubtitle: View {
//    var text: String
//    var body: some View {
//        Text(LocalizedStringKey(text))
//            .tracking(-0.5)
//            .foregroundColor(.gray200)
//            .font(semiBold16Font)
//            .padding(.top, Size.w(25))
//    }
//}
//
//struct TextHead: View {
//    var text: String
//    var body: some View {
//        Text(LocalizedStringKey(text))
//            .tracking(-0.5)
//            .foregroundColor(.gray400)
//            .font(semiBold16Font)
//            .padding(.bottom, Size.w(-7))
//            .padding(.top, Size.w(15))
//    }
//}
//
//struct TextMarker: View {
//    var text: String
//    var body: some View {
//        HStack {
//            Text("\u{2022}") +
//            Text(LocalizedStringKey(text))
//                .tracking(-0.5)
//        }.foregroundColor(.gray400)
//         .font(light14Font)
//         .lineSpacing(Size.w(8))
//         .padding(.top, Size.w(15))
//    }
//}
