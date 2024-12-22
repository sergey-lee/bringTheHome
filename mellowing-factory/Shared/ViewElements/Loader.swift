//
//  Loader.swift
//  mellowing-factory
//
//  Created by Florian Topf on 11.12.21.
//

import SwiftUI

struct Loader: View {
    var color: Color
    var scale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: color))
                .scaleEffect(scale, anchor: .center)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
        .background(Color.clear)
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader(color: .white, scale: 1.2)
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 11 Pro")
    }
}
