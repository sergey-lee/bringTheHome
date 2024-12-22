//
//  CustomSlider.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/11/17.
//

import SwiftUI

struct CustomSlider: View {
    
    @Binding var value: CGFloat
    @Binding var endValue: CGFloat
    @Binding var enabled: Bool
    
    @State var lastOffset: CGFloat = 0
    
    var range: ClosedRange<CGFloat>
    
    var knobSize: CGSize = CGSize(width: Size.h(24), height: Size.h(24))
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: Size.h(6))
                    .frame(height: Size.h(6))
                    .foreground(Color.gray50)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let sliderPos = value.location.x
                                let sliderVal = sliderPos.map(from: 0...(geometry.size.width - self.knobSize.width), to: self.range)
                                withAnimation {
                                    if sliderVal > range.upperBound {
                                        self.value = range.upperBound
                                        self.endValue = range.upperBound
                                    } else if sliderVal < range.lowerBound {
                                        self.value = range.lowerBound
                                        self.endValue = range.lowerBound
                                    } else {
                                        self.value = sliderVal
                                        self.endValue = sliderVal
                                    }
                                }
                            }
                        
                    )
                //MARK: Track
                HStack {
                    RoundedCorner(radius: Size.h(6), corners: enabled ? [.bottomLeft, .topLeft] : [.allCorners])
//                    RoundedRectangle(cornerRadius: Size.h(6))
                        .frame(width: self.$value.wrappedValue.map(from: self.range, to: 0...(geometry.size.width - self.knobSize.width)), height: Size.h(6))
                        .foreground(enabled ? Color.green400 : Color.gray300)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onEnded { value in
                                    let sliderPos = value.location.x
                                    let sliderVal = sliderPos.map(from: 0...(geometry.size.width - self.knobSize.width), to: self.range)
                                    withAnimation {
                                        if sliderVal > range.upperBound {
                                            self.value = range.upperBound
                                            self.endValue = range.upperBound
                                        } else if sliderVal < range.lowerBound {
                                            self.value = range.lowerBound
                                            self.endValue = range.lowerBound
                                        } else {
                                            self.value = sliderVal
                                            self.endValue = sliderVal
                                        }
                                    }
                                }
                        )
                    Spacer()
                }.frame(height: Size.h(24))
                //MARK: Knob
                HStack {
                    Color.white
                        .frame(width: enabled ? self.knobSize.width : 0, height: enabled ? self.knobSize.height : 0)
                        .cornerRadius(Size.h(12))
                        .shadow(color: Color.gray200, radius: 10)
                        .offset(x: self.$value.wrappedValue.map(from: self.range, to: 0...(geometry.size.width - self.knobSize.width)))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    if abs(value.translation.width) < 0.1 {
                                        self.lastOffset = self.$value.wrappedValue.map(from: self.range, to: 0...(geometry.size.width - self.knobSize.width))
                                    }
                                    
                                    let sliderPos = max(0, min(self.lastOffset + value.translation.width, geometry.size.width - self.knobSize.width))
                                    let sliderVal = sliderPos.map(from: 0...(geometry.size.width - self.knobSize.width), to: self.range)

                                    self.value = sliderVal
                                }
                                .onEnded { value in
                                    if abs(value.translation.width) < 0.1 {
                                        self.lastOffset = self.$value.wrappedValue.map(from: self.range, to: 0...(geometry.size.width - self.knobSize.width))
                                    }
                                    
                                    let sliderPos = max(0, min(self.lastOffset + value.translation.width, geometry.size.width - self.knobSize.width))
                                    
                                    let sliderVal = sliderPos.map(from: 0...(geometry.size.width - self.knobSize.width), to: self.range)
                                    
                                    self.endValue = sliderVal
                                }
                                
                    )
                    Spacer()
                }
                .opacity(enabled ? 1 : 0)
            }
        }.disabled(!enabled)
         .frame(height: Size.h(24))
    }
}

extension View {
    public func foreground<Overlay: View>(_ overlay: Overlay) -> some View {
      self.overlay(overlay).mask(self)
    }
}


extension CGFloat {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
        let result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
        return result
    }
}
