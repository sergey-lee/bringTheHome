//
//  NavigationLine.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/04/05.
//

import SwiftUI

struct NavigationLine<Content: View>: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let content: () -> Content
    
    var body: some View {
        NavigationLink(destination: {
            content()
        }) {
            VStack {
                HStack {
                    Text(title)
                        .font(regular18Font)
                        .foregroundColor(.gray500)
                        .padding(.leading, Size.w(10))
                    Spacer()
                    Text(subtitle)
                        .font(regular16Font)
                        .foregroundColor(.gray400)
                        .padding(.trailing, Size.w(5))
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray300)
                        .frame(width: Size.w(8), height: Size.h(16))
                }.padding(.horizontal, Size.w(30))
                    .padding(.bottom, Size.h(10))
                Divider().padding(.horizontal, Size.w(16))
                    .padding(.bottom, Size.h(8))
            }
        }
    }
}
