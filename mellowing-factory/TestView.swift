//
//  TestView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/22.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack {
            Rectangle()
                
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Stripes(color: Color.red300)
                .frame(width: 100, height: 100)
        }
    }
}
