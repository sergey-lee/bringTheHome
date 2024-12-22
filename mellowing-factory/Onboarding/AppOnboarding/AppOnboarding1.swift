//
//  AppOnboarding1.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/08/08.
//

import SwiftUI

struct AppOnboarding1: View {
    @Binding var selection: Int

    var body: some View {
        ZStack(alignment: .top) {
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
                        RadialGradient(colors: [.black, Color.blue500], center: .bottom, startRadius: 0, endRadius: 350).opacity(0.45)
                        RadialGradient(colors: [.black, Color.blue500], center: .bottom, startRadius: 0, endRadius: 350).opacity(0.45)
                    }
                    MoonAndStars
                }
                .frame(height: Size.h(350))
                .ignoresSafeArea(edges: .top)

                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Text("EFFORTLESS")
                            .padding(.bottom, -5)
                        Text("SLEEP_INDUCTION")
                    }
                        .font(medium30Font)
                        .padding(.bottom, Size.w(32))
                    
                    Text("APP_ONB.DESC1")
                        .lineSpacing(Size.w(8))
                        .font(regular18Font)
                        .padding(.horizontal, Size.w(16))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, Size.w(70))

                    BlueButtonView(title: "NEXT", action: {
                        withAnimation {
                            selection = 2
                        }
                    })
                        .padding(.bottom, 20)
//                        .padding(.bottom, Size.safeArea().bottom)
                }
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Size.w(16))
            }
        }
    }
    
    var MoonAndStars: some View {
        VStack(spacing: 0) {
            let width: CGFloat = Size.w(180)
            
            HStack {
                RoundedStarView()
                    .rotationEffect(.degrees(-42))
                    .padding(.trailing, Size.w(15))
            }
            .frame(width: Size.w(110), alignment: .center)
            .padding(.bottom, Size.h(24))
            
            HStack {
                RoundedStarView()
                    .rotationEffect(.degrees(-21))
            }
            .frame(width: Size.w(110), alignment: .leading)
            .padding(.bottom, Size.h(5))
            
            ZStack {
                ZStack {
                    HStack {
                        RoundedStarView()
                            .rotationEffect(.degrees(30))
                    }.frame(width: Size.w(130), height: Size.w(60), alignment: .topTrailing)
                    
                    Image("moon")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue200)
                        .frame(width: Size.w(62), height: Size.w(60))
                }
                
                ZStack {
                    HalfCircle()
                        .stroke(LinearGradient(colors: [
                            .white,
                            Color(red: 236/255, green: 246/255, blue: 255/255, opacity: 1),
                            Color(red: 121/255, green: 192/255, blue: 255/255, opacity: 0.6),
                        ], startPoint: .top, endPoint: .bottom))
                        .opacity(0.8)
                    Blur(style: .systemUltraThinMaterialLight, intensity: 0.2)
                        .clipShape(HalfCircle())
                }
                .frame(width: width, height: width * 0.65)
                .offset(y: Size.w(55))
            }
        }
    }
}

struct HalfCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        let point1: CGFloat = 0.66667

        path.move(to: CGPoint(x: 0.8*width, y: point1*height))
        path.addCurve(to: CGPoint(x: 0.83167*width, y: 0.61675*height), control1: CGPoint(x: 0.81841*width, y: point1*height), control2: CGPoint(x: 0.83351*width, y: 0.64423*height))
        path.addCurve(to: CGPoint(x: 0.80796*width, y: 0.47532*height), control1: CGPoint(x: 0.82842*width, y: 0.56821*height), control2: CGPoint(x: 0.82045*width, y: 0.52056*height))
        path.addCurve(to: CGPoint(x: 0.7357*width, y: 0.31311*height), control1: CGPoint(x: 0.79121*width, y: 0.41466*height), control2: CGPoint(x: 0.76666*width, y: 0.35954*height))
        path.addCurve(to: CGPoint(x: 0.62756*width, y: 0.20473*height), control1: CGPoint(x: 0.70475*width, y: 0.26668*height), control2: CGPoint(x: 0.66801*width, y: 0.22985*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.16667*height), control1: CGPoint(x: 0.58712*width, y: 0.1796*height), control2: CGPoint(x: 0.54377*width, y: 0.16667*height))
        path.addCurve(to: CGPoint(x: 0.37244*width, y: 0.20473*height), control1: CGPoint(x: 0.45623*width, y: 0.16667*height), control2: CGPoint(x: 0.41288*width, y: 0.1796*height))
        path.addCurve(to: CGPoint(x: 0.2643*width, y: 0.31311*height), control1: CGPoint(x: 0.332*width, y: 0.22985*height), control2: CGPoint(x: 0.29525*width, y: 0.26668*height))
        path.addCurve(to: CGPoint(x: 0.19204*width, y: 0.47532*height), control1: CGPoint(x: 0.23334*width, y: 0.35954*height), control2: CGPoint(x: 0.20879*width, y: 0.41466*height))
        path.addCurve(to: CGPoint(x: 0.16833*width, y: 0.61675*height), control1: CGPoint(x: 0.17955*width, y: 0.52056*height), control2: CGPoint(x: 0.17158*width, y: 0.56821*height))
        path.addCurve(to: CGPoint(x: 0.2*width, y: point1*height), control1: CGPoint(x: 0.16649*width, y: 0.64423*height), control2: CGPoint(x: 0.18159*width, y: point1*height))
        path.addLine(to: CGPoint(x: 0.5*width, y: point1*height))
        path.addLine(to: CGPoint(x: 0.8*width, y: point1*height))
        path.closeSubpath()
        return path
    }
}

struct AppOnboarding1_Previews: PreviewProvider {
    static var previews: some View {
        AppOnboarding1(selection: .constant(1))
    }
}
