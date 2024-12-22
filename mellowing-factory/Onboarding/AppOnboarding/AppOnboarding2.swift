//
//  AppOnboarding2.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/07/26.
//

import SwiftUI

struct AppOnboarding2: View {
    @Binding var selection: Int

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
                            Color(red: 238/255, green: 246/255, blue: 254/255),
                            Color(red: 81/255, green: 179/255, blue: 230/255),
                            Color(red: 54/255, green: 124/255, blue: 244/255),
                            Color(red: 28/255, green: 72/255, blue: 208/255),
                                               ], center: .bottom, startRadius: 0, endRadius: 350)
                    }
                    VStack(spacing: 0) {
                        Spacer()
                        DropsLineView()
                            .offset(y: Size.w(55))
                        PillowView()
                            
                    }
                }
                .frame(height: Size.h(350))
                .ignoresSafeArea(edges: .top)
                
                VStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: Size.w(-5)) {
                        Text("GAIN_INSIGHTS")
                        Text("INTO_YOUR_SLEEP")
                    }
                        .font(medium30Font)
                        .padding(.bottom, Size.w(32))
    
                    Text("APP_ONB.DESC2")
                        .lineSpacing(Size.w(8))
                        .font(regular18Font)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, Size.w(70))

                    BlueButtonView(title: "NEXT", action: {
                        withAnimation {
                            selection = 3
                        }
                    })
                    .padding(.bottom, Size.w(20))
//                    .padding(.bottom, Size.safeArea().bottom)
                }
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Size.w(16))
            }
        }
    }
}

struct PillowView: View {
    var body: some View {
        ZStack {
            Image("pillow-big")
                .resizable()
                .scaledToFit()
                .frame(width: Size.w(96), height: Size.w(56))
                .offset(y: Size.h(20))
            
            ZStack {
                Pillow()
                    .stroke(LinearGradient(colors: [
                        .white,
                        Color(red: 236/255, green: 246/255, blue: 255/255, opacity: 1),
                        Color(red: 121/255, green: 192/255, blue: 255/255, opacity: 0.6),
                    ], startPoint: .top, endPoint: .bottom))
                    .opacity(0.8)
                Blur(style: .systemUltraThinMaterialLight, intensity: 0.2)
                    .clipShape(Pillow())
            }
            .frame(width: Size.w(120), height: Size.w(120))
            .offset(y: Size.w(55))
        }
    }
}

struct AppOnboarding2_Previews: PreviewProvider {
    static var previews: some View {
        AppOnboarding2(selection: .constant(1))
    }
}

struct DropView: View {
    var height: CGFloat = 3
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .stroke(Color.white.opacity(0.4), lineWidth: 1.5)
            .frame(width: 3, height: height)
    }
}

struct DropsLineView: View {
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                VStack {
                    DropView(height: 40).opacity(0)
                    DropView()
                    DropView()
                    DropView(height: 20)
                    DropView()
                }
                VStack {
                    DropView()
                    DropView(height: 20)
                    DropView()
                    DropView(height: 28)
                    DropView(height: 20).opacity(0)
                }
                
                VStack {
                    DropView(height: 23).opacity(0)
                    DropView(height: 38)
                    DropView()
                    DropView(height: 13)
                    DropView(height: 10).opacity(0)
                }
            }
            .padding()
            .mask(
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.7), Color.clear]), startPoint: .bottom, endPoint: .top)
                       )
        }
    }
}

struct Pillow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.25103*width, y: 0.59921*height))
        path.addCurve(to: CGPoint(x: 0.2459*width, y: 0.62148*height), control1: CGPoint(x: 0.24775*width, y: 0.60593*height), control2: CGPoint(x: 0.2459*width, y: 0.61349*height))
        path.addCurve(to: CGPoint(x: 0.29638*width, y: 0.67213*height), control1: CGPoint(x: 0.2459*width, y: 0.64946*height), control2: CGPoint(x: 0.2685*width, y: 0.67213*height))
        path.addCurve(to: CGPoint(x: 0.31859*width, y: 0.66698*height), control1: CGPoint(x: 0.30435*width, y: 0.67213*height), control2: CGPoint(x: 0.31189*width, y: 0.67028*height))
        path.addCurve(to: CGPoint(x: 0.68141*width, y: 0.66698*height), control1: CGPoint(x: 0.37585*width, y: 0.6388*height), control2: CGPoint(x: 0.61806*width, y: 0.63581*height))
        path.addCurve(to: CGPoint(x: 0.70362*width, y: 0.67213*height), control1: CGPoint(x: 0.68811*width, y: 0.67028*height), control2: CGPoint(x: 0.69565*width, y: 0.67213*height))
        path.addCurve(to: CGPoint(x: 0.7541*width, y: 0.62148*height), control1: CGPoint(x: 0.7315*width, y: 0.67213*height), control2: CGPoint(x: 0.7541*width, y: 0.64946*height))
        path.addCurve(to: CGPoint(x: 0.74897*width, y: 0.59921*height), control1: CGPoint(x: 0.7541*width, y: 0.61349*height), control2: CGPoint(x: 0.75225*width, y: 0.60593*height))
        path.addCurve(to: CGPoint(x: 0.74897*width, y: 0.23686*height), control1: CGPoint(x: 0.71514*width, y: 0.53*height), control2: CGPoint(x: 0.72606*width, y: 0.28372*height))
        path.addCurve(to: CGPoint(x: 0.7541*width, y: 0.21459*height), control1: CGPoint(x: 0.75225*width, y: 0.23014*height), control2: CGPoint(x: 0.7541*width, y: 0.22258*height))
        path.addCurve(to: CGPoint(x: 0.70362*width, y: 0.16393*height), control1: CGPoint(x: 0.7541*width, y: 0.18661*height), control2: CGPoint(x: 0.7315*width, y: 0.16393*height))
        path.addCurve(to: CGPoint(x: 0.68141*width, y: 0.16908*height), control1: CGPoint(x: 0.69565*width, y: 0.16393*height), control2: CGPoint(x: 0.68811*width, y: 0.16579*height))
        path.addCurve(to: CGPoint(x: 0.31859*width, y: 0.16908*height), control1: CGPoint(x: 0.61244*width, y: 0.20303*height), control2: CGPoint(x: 0.36509*width, y: 0.19197*height))
        path.addCurve(to: CGPoint(x: 0.29638*width, y: 0.16393*height), control1: CGPoint(x: 0.31189*width, y: 0.16579*height), control2: CGPoint(x: 0.30435*width, y: 0.16393*height))
        path.addCurve(to: CGPoint(x: 0.2459*width, y: 0.21459*height), control1: CGPoint(x: 0.2685*width, y: 0.16393*height), control2: CGPoint(x: 0.2459*width, y: 0.18661*height))
        path.addCurve(to: CGPoint(x: 0.25103*width, y: 0.23686*height), control1: CGPoint(x: 0.2459*width, y: 0.22258*height), control2: CGPoint(x: 0.24775*width, y: 0.23014*height))
        path.addCurve(to: CGPoint(x: 0.25103*width, y: 0.59921*height), control1: CGPoint(x: 0.28486*width, y: 0.30607*height), control2: CGPoint(x: 0.27394*width, y: 0.55235*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.31678*width, y: 0.66331*height))
        path.addLine(to: CGPoint(x: 0.31678*width, y: 0.66331*height))
        path.addCurve(to: CGPoint(x: 0.39005*width, y: 0.64664*height), control1: CGPoint(x: 0.33178*width, y: 0.65592*height), control2: CGPoint(x: 0.35829*width, y: 0.6504*height))
        path.addCurve(to: CGPoint(x: 0.4977*width, y: 0.64063*height), control1: CGPoint(x: 0.42198*width, y: 0.64286*height), control2: CGPoint(x: 0.45976*width, y: 0.64082*height))
        path.addCurve(to: CGPoint(x: 0.60651*width, y: 0.6458*height), control1: CGPoint(x: 0.53563*width, y: 0.64044*height), control2: CGPoint(x: 0.5738*width, y: 0.64211*height))
        path.addCurve(to: CGPoint(x: 0.68322*width, y: 0.66331*height), control1: CGPoint(x: 0.63906*width, y: 0.64946*height), control2: CGPoint(x: 0.6667*width, y: 0.65517*height))
        path.addCurve(to: CGPoint(x: 0.70362*width, y: 0.66803*height), control1: CGPoint(x: 0.68937*width, y: 0.66633*height), control2: CGPoint(x: 0.69629*width, y: 0.66803*height))
        path.addCurve(to: CGPoint(x: 0.75*width, y: 0.62148*height), control1: CGPoint(x: 0.72922*width, y: 0.66803*height), control2: CGPoint(x: 0.75*width, y: 0.64721*height))
        path.addCurve(to: CGPoint(x: 0.74528*width, y: 0.60101*height), control1: CGPoint(x: 0.75*width, y: 0.61413*height), control2: CGPoint(x: 0.7483*width, y: 0.60718*height))
        path.addCurve(to: CGPoint(x: 0.7274*width, y: 0.52039*height), control1: CGPoint(x: 0.73648*width, y: 0.583*height), control2: CGPoint(x: 0.73078*width, y: 0.554*height))
        path.addCurve(to: CGPoint(x: 0.72359*width, y: 0.40958*height), control1: CGPoint(x: 0.724*width, y: 0.48664*height), control2: CGPoint(x: 0.72291*width, y: 0.44773*height))
        path.addCurve(to: CGPoint(x: 0.73048*width, y: 0.30302*height), control1: CGPoint(x: 0.72428*width, y: 0.37143*height), control2: CGPoint(x: 0.72674*width, y: 0.33395*height))
        path.addCurve(to: CGPoint(x: 0.73699*width, y: 0.26219*height), control1: CGPoint(x: 0.73235*width, y: 0.28757*height), control2: CGPoint(x: 0.73454*width, y: 0.2737*height))
        path.addCurve(to: CGPoint(x: 0.74528*width, y: 0.23506*height), control1: CGPoint(x: 0.73944*width, y: 0.25075*height), control2: CGPoint(x: 0.7422*width, y: 0.24138*height))
        path.addLine(to: CGPoint(x: 0.74528*width, y: 0.23506*height))
        path.addCurve(to: CGPoint(x: 0.75*width, y: 0.21459*height), control1: CGPoint(x: 0.7483*width, y: 0.22889*height), control2: CGPoint(x: 0.75*width, y: 0.22194*height))
        path.addCurve(to: CGPoint(x: 0.70362*width, y: 0.16803*height), control1: CGPoint(x: 0.75*width, y: 0.18886*height), control2: CGPoint(x: 0.72922*width, y: 0.16803*height))
        path.addCurve(to: CGPoint(x: 0.68322*width, y: 0.17276*height), control1: CGPoint(x: 0.69629*width, y: 0.16803*height), control2: CGPoint(x: 0.68937*width, y: 0.16973*height))
        path.addCurve(to: CGPoint(x: 0.60257*width, y: 0.1907*height), control1: CGPoint(x: 0.66527*width, y: 0.1816*height), control2: CGPoint(x: 0.63624*width, y: 0.18732*height))
        path.addCurve(to: CGPoint(x: 0.4915*width, y: 0.19449*height), control1: CGPoint(x: 0.56875*width, y: 0.1941*height), control2: CGPoint(x: 0.52975*width, y: 0.19519*height))
        path.addCurve(to: CGPoint(x: 0.3847*width, y: 0.18758*height), control1: CGPoint(x: 0.45325*width, y: 0.1938*height), control2: CGPoint(x: 0.41567*width, y: 0.19132*height))
        path.addCurve(to: CGPoint(x: 0.34384*width, y: 0.18105*height), control1: CGPoint(x: 0.36922*width, y: 0.18571*height), control2: CGPoint(x: 0.35535*width, y: 0.18351*height))
        path.addCurve(to: CGPoint(x: 0.31678*width, y: 0.17276*height), control1: CGPoint(x: 0.33241*width, y: 0.17861*height), control2: CGPoint(x: 0.32306*width, y: 0.17585*height))
        path.addLine(to: CGPoint(x: 0.31678*width, y: 0.17276*height))
        path.addCurve(to: CGPoint(x: 0.29638*width, y: 0.16803*height), control1: CGPoint(x: 0.31063*width, y: 0.16973*height), control2: CGPoint(x: 0.30371*width, y: 0.16803*height))
        path.addCurve(to: CGPoint(x: 0.25*width, y: 0.21459*height), control1: CGPoint(x: 0.27078*width, y: 0.16803*height), control2: CGPoint(x: 0.25*width, y: 0.18886*height))
        path.addCurve(to: CGPoint(x: 0.25471*width, y: 0.23506*height), control1: CGPoint(x: 0.25*width, y: 0.22194*height), control2: CGPoint(x: 0.2517*width, y: 0.22889*height))
        path.addCurve(to: CGPoint(x: 0.2726*width, y: 0.31567*height), control1: CGPoint(x: 0.26352*width, y: 0.25307*height), control2: CGPoint(x: 0.26922*width, y: 0.28207*height))
        path.addCurve(to: CGPoint(x: 0.27641*width, y: 0.42649*height), control1: CGPoint(x: 0.276*width, y: 0.34943*height), control2: CGPoint(x: 0.27709*width, y: 0.38834*height))
        path.addCurve(to: CGPoint(x: 0.26952*width, y: 0.53304*height), control1: CGPoint(x: 0.27572*width, y: 0.46464*height), control2: CGPoint(x: 0.27326*width, y: 0.50212*height))
        path.addCurve(to: CGPoint(x: 0.263*width, y: 0.57388*height), control1: CGPoint(x: 0.26765*width, y: 0.5485*height), control2: CGPoint(x: 0.26546*width, y: 0.56237*height))
        path.addCurve(to: CGPoint(x: 0.25471*width, y: 0.60101*height), control1: CGPoint(x: 0.26056*width, y: 0.58532*height), control2: CGPoint(x: 0.2578*width, y: 0.59469*height))
        path.addCurve(to: CGPoint(x: 0.25*width, y: 0.62148*height), control1: CGPoint(x: 0.2517*width, y: 0.60718*height), control2: CGPoint(x: 0.25*width, y: 0.61412*height))
        path.addCurve(to: CGPoint(x: 0.29638*width, y: 0.66803*height), control1: CGPoint(x: 0.25*width, y: 0.64721*height), control2: CGPoint(x: 0.27078*width, y: 0.66803*height))
        path.addCurve(to: CGPoint(x: 0.31678*width, y: 0.66331*height), control1: CGPoint(x: 0.30371*width, y: 0.66803*height), control2: CGPoint(x: 0.31063*width, y: 0.66633*height))
        path.closeSubpath()
        return path
    }
}
