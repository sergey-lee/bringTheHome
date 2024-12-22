//
//  InductionBackground.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/04/28.
//

import SwiftUI

struct InductionBackground: View {
    @Binding var sleepInductionStarted: Bool
    @State var xOffset: CGFloat = 1
    @State var yOffset: CGFloat = 0
    var maxHeight: CGFloat = 400
    
    var body: some View {
        VStack {
            GeometryReader { reader in
                ZStack(alignment: .topLeading) {
                    if sleepInductionStarted {
                        Image("lights-bg")
                            .resizable()
                            .frame(width: reader.size.width * 2, height: reader.size.height * 2)
                            .offset(x: xOffset, y: yOffset)
                            .onAppear {
                                runAnimation(reader: reader)
                            }
                    } else {
                        Color.white
                    }
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: Size.h(maxHeight))
            .clipped()
//            .offset(y: Size.h(-5))
    }
    
    private func runAnimation(reader: GeometryProxy) {
        let frame: CGFloat = 4
        DispatchQueue.main.async {
            withAnimation(.linear(duration: frame)) {
                xOffset = -reader.size.width
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + frame) {
                withAnimation(.linear(duration: frame)) {
                    yOffset = -reader.size.height
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + frame * 2) {
                withAnimation(.linear(duration: frame)) {
                    xOffset = 0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + frame * 3) {
                withAnimation(.linear(duration: frame)) {
                    yOffset = 0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + frame * 4) {
                runAnimation(reader: reader)
            }
        }
    }
}

struct ClipAnimationTest_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InductionBackground(sleepInductionStarted: .constant(true))
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        
    }
}
