//
//  AppOnboarding3.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/07/26.
//

import SwiftUI

struct AppOnboarding3: View {
    @EnvironmentObject var sessionManager: SessionManager

    var body: some View {
        ZStack {
            ZStack {
                Color.blue801
                RadialGradient(colors: [.blue100.opacity(0.5), Color.clear], center: .leading, startRadius: 0, endRadius: 200).opacity(0.4)
                RadialGradient(colors: [.green100, Color.clear], center: .bottomTrailing, startRadius: 0, endRadius: 400).opacity(0.5)
            }
            .ignoresSafeArea()
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    ZStack(alignment: .bottom) {
                        Color.blue500
                        
                        RadialGradient(colors: [
                            Color(red: 255/255, green: 255/255, blue: 255/255),
                            Color(red: 82/255, green: 179/255, blue: 231/255),
                            Color(red: 15/255, green: 41/255, blue: 128/255),
                                               ], center: .bottom, startRadius: 0, endRadius: 450)
                        Circle()
                            .trim(from: 0.5, to: 1)
                            .foregroundColor(Color.yellow500.opacity(0.3))
                            .frame(width: 150, height: 150)
                            .blur(radius: 20)
                            .offset(y: 75)
                    }

                    SunView
                        .overlay(
                            ZStack {
                                arrowUp()
                                    .offset(x: Size.w(40), y: Size.w(-85))
                                arrowUp()
                                    .offset(x: Size.w(40), y: Size.w(-65))
                                arrowUp(masked: false)
                                    .offset(x: Size.w(40), y: Size.w(-45))
                            }
                        )
                }
                .frame(height: Size.h(350))
                .ignoresSafeArea(edges: .top)
                
                VStack(spacing: 0) {
                    Spacer()
                    Text("APP_ONB.TITLE3")
                        .font(medium30Font)
                        .fixedSize()
                        .padding(.bottom, Size.w(32))
                 
                    Text("APP_ONB.DESC3")
                        .lineSpacing(6)
                        .font(regular18Font)
                        .lineLimit(4)
                        .padding(.bottom, Size.w(70))
                    
                    PrimaryButtonView(title: "START", action: skip)
                        .padding(.bottom, 20)
//                        .padding(.bottom, Size.safeArea().bottom)
                }
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Size.w(16))
            }
        }
    }
    
    func arrowUp(masked: Bool = true) -> some View {
        ZStack {
            ArrowUpShape()
                .stroke(Color.white.opacity(0.7), lineWidth: 1.6)
            Blur(style: .systemUltraThinMaterialLight, intensity: 0.6)
            
                .clipShape(ArrowUpShape())
        }
        .frame(width: 29, height: 43)
        .opacity(0.7)
        .padding(10)
        .mask(
            LinearGradient(gradient: Gradient(colors: masked ? [Color.black.opacity(0.6), Color.black.opacity(0.3), Color.clear, Color.clear] : [Color.black]), startPoint: .top, endPoint: .bottom)
        )
    }
    
    var SunView: some View {
        ZStack {
            
            let width: CGFloat = Size.w(180)
            
            Circle()
                .fill(Color.yellow500)
                .frame(width: Size.w(54), height: Size.w(54))
                .shadow(color: Color.yellow, radius: 25)
                .offset(y: Size.w(15))
            ZStack {
                HalfCircle()
                    .stroke(LinearGradient(colors: [
                        .white,
                        Color(red: 255/255, green: 255/255, blue: 214/255, opacity: 1),
                        Color(red: 255/255, green: 187/255, blue: 0/255, opacity: 0.6),
                    ], startPoint: .top, endPoint: .bottom))
                    .opacity(0.8)
                HalfCircle()
                    .fill(Color.white)
                    .opacity(0.2)
                Blur(style: .systemUltraThinMaterialLight, intensity: 0.2)
                
                    .clipShape(HalfCircle())
            }
            .frame(width: width, height: width * 0.65)
            .rotationEffect(.degrees(180))
            .offset(y: Size.w(40))
        }
    }
    
    private func skip() {
        Defaults.isAppOnboarded = true
        sessionManager.getCurrentAuthSession()
    }
}

struct AppOnboarding3_Previews: PreviewProvider {
    static var previews: some View {
        AppOnboarding3()
    }
}

struct ArrowUpShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.9874*width, y: 0.30913*height))
        path.addLine(to: CGPoint(x: 0.59233*width, y: 0.00914*height))
        path.addCurve(to: CGPoint(x: 0.53123*width, y: 0.00914*height), control1: CGPoint(x: 0.57548*width, y: -0.00305*height), control2: CGPoint(x: 0.54809*width, y: -0.00305*height))
        path.addLine(to: CGPoint(x: 0.13617*width, y: 0.30913*height))
        path.addCurve(to: CGPoint(x: 0.12675*width, y: 0.3432*height), control1: CGPoint(x: 0.12372*width, y: 0.31813*height), control2: CGPoint(x: 0.12*width, y: 0.33151*height))
        path.addCurve(to: CGPoint(x: 0.16667*width, y: 0.36251*height), control1: CGPoint(x: 0.1334*width, y: 0.35489*height), control2: CGPoint(x: 0.14921*width, y: 0.36251*height))
        path.addLine(to: CGPoint(x: 0.34569*width, y: 0.36251*height))
        path.addLine(to: CGPoint(x: 0.34569*width, y: 0.60813*height))
        path.addCurve(to: CGPoint(x: 0.25832*width, y: 0.80969*height), control1: CGPoint(x: 0.34569*width, y: 0.68038*height), control2: CGPoint(x: 0.31544*width, y: 0.75007*height))
        path.addCurve(to: CGPoint(x: 0.028*width, y: 0.9395*height), control1: CGPoint(x: 0.20128*width, y: 0.86919*height), control2: CGPoint(x: 0.12168*width, y: 0.91406*height))
        path.addCurve(to: CGPoint(x: 0.00069*width, y: 0.97431*height), control1: CGPoint(x: 0.00847*width, y: 0.94481*height), control2: CGPoint(x: -0.00302*width, y: 0.95944*height))
        path.addCurve(to: CGPoint(x: 0.04321*width, y: height), control1: CGPoint(x: 0.00441*width, y: 0.98919*height), control2: CGPoint(x: 0.0223*width, y: height))
        path.addLine(to: CGPoint(x: 0.28865*width, y: height))
        path.addCurve(to: CGPoint(x: 0.77779*width, y: 0.58376*height), control1: CGPoint(x: 0.58577*width, y: height), control2: CGPoint(x: 0.77779*width, y: 0.83663*height))
        path.addLine(to: CGPoint(x: 0.77779*width, y: 0.36251*height))
        path.addLine(to: CGPoint(x: 0.95681*width, y: 0.36251*height))
        path.addCurve(to: CGPoint(x: 0.99673*width, y: 0.3432*height), control1: CGPoint(x: 0.97427*width, y: 0.36251*height), control2: CGPoint(x: 0.99008*width, y: 0.35489*height))
        path.addCurve(to: CGPoint(x: 0.9874*width, y: 0.30913*height), control1: CGPoint(x: 1.00339*width, y: 0.33151*height), control2: CGPoint(x: 0.99967*width, y: 0.31813*height))
        path.closeSubpath()
        return path
    }
}
