//
//  NavigationWrapper.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/28.
//

import SwiftUI

struct NavigationWrapper<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let title: LocalizedStringKey
    @ViewBuilder var content: Content
    
    var body: some View {
        ZStack {
            content
        }
        .navigationView(back: back, title: title, bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
    }
    
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct NavigationWrapper_Previews: PreviewProvider {
    static var previews: some View {
        NavigationWrapper(title: "Terms of Service") {}
    }
}
