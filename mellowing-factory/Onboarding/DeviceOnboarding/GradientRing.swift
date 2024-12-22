//
//  GradientRing.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/25.
//

import SwiftUI

struct GradientRing: View {
    @Binding var animation: Bool
    var width: CGFloat = 1
    var lightIsOn: Bool = false
    let size: CGFloat
    
    
    var body: some View {
        ZStack(alignment: .top) {
            if lightIsOn {
                ZStack {
                    Ellipse()
                        .fill(Color.white)
                        .frame(width: Size.w(animation ? 10 : 7), height: Size.w(animation ? 5 : 3))
                        
                    Ellipse()
                        .fill(Color.white)
                        .frame(width: Size.w(animation ? 25 : 19), height: Size.w(animation ? 8 : 6))
                        .shadow(color: Color.white, radius: 20)
                        .shadow(color: Color.white, radius: 20)
                        .shadow(color: Color.white, radius: 15)
                        .shadow(color: Color.white, radius: 20, y: Size.w(60))
                        .blur(radius: 3)
                }.offset(y: Size.w(animation ? -4 : -3))
            }
            Circle()
                .stroke(LinearGradient(colors: [.white, .green100, .blue100, .blue200.opacity(0.5), .blue400.opacity(0.3), .blue400.opacity(0.2), .blue500.opacity(0.1)], startPoint: .top, endPoint: .bottom), lineWidth: width)
                .frame(width: Size.w(size), height: Size.w(size))
        }
    }
}

struct GradientRing_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            GradientRing(animation: .constant(false), lightIsOn: true, size: 264)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea()
        .background(Color.blue700).ignoresSafeArea()
        
    }
}
