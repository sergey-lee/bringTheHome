//
//  BackButton.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/12/21.
//

import SwiftUI

struct BackButton: View {
    let action: () -> Void
    var hidden: Bool = false
    var color: Color = Color.gray800
    
    var body: some View {
        if !hidden {
            Button(action: action) {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(color)
                    .frame(width: 10, height: 20)
            }
        }
    }
}
