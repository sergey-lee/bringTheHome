//
//  LoadingBox.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/07/17.
//

import SwiftUI

struct LoadingBox: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                .scaleEffect(1.4)
                .padding(30)
        }
        .background(Blur(style: .systemUltraThinMaterialDark, intensity: 0.4))
        
        .cornerRadius(20)
    }
}

struct LoadingBox_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LoadingBox()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue)
    }
}
