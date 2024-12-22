//
//  AnimatedBG.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/15.
//

import SwiftUI

struct AnimatedBG: View {
    @State var xOffset: CGFloat = 1
    @State var yOffset: CGFloat = 0
    var image = "lights-bg"
    var maxHeight: CGFloat = 400
    
    var body: some View {
        VStack {
            GeometryReader { reader in
                ZStack(alignment: .topLeading) {
                    Image(image)
                        .resizable()
//                        .scaledToFit()
                        .frame(width: reader.size.width * 3, height: reader.size.height * 2)
                        .offset(x: xOffset, y: yOffset)
                        .onAppear {
                            runAnimation(reader: reader)
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
    
    private func runAnimation(reader: GeometryProxy) {
        let frame: CGFloat = 4
        DispatchQueue.main.async {
            withAnimation(.linear(duration: frame * 2)) {
                xOffset = -reader.size.width * 2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + frame * 2) {
                withAnimation(.linear(duration: frame)) {
                    yOffset = -reader.size.height
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + frame * 3) {
                withAnimation(.linear(duration: frame * 2)) {
                    xOffset = 0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + frame * 4) {
                withAnimation(.linear(duration: frame)) {
                    yOffset = 0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + frame * 5) {
                runAnimation(reader: reader)
            }
        }
    }
}
