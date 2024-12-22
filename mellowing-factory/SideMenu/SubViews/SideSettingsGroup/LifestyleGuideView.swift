//
//  LifestyleGuideView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/07/12.
//

import SwiftUI

struct LifestyleGuideView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var offset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                Color.gray1100
                Color("blue-lifestyle-bg")
            }
            .frame(maxWidth: .infinity)
            TrackableScrollView(showIndicators: false, contentOffset: $offset) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        Image("lifestyle-bg1")
                            .resizable()
                            .scaledToFit()
                        
                        VStack(spacing: 0) {
                            TopView
                            EveningView
                            NightView
                            SleepView
                            CarouselSlider(height: 150)
                                .frame(maxWidth: UIScreen.main.bounds.width)
                        }
                    }
                    
                    MorningView
                    MorningInsightsView
                    BottomView
                }
                .padding(.top, 44 + 50)
                .padding(.top, Size.safeArea().top)
            }
            
            ZStack {
                BackButton(action: {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }, color: .gray500)
                .frame(width: 44, height: 44)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image("wethm-logo-text")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: Size.w(70), height: Size.h(16))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .opacity(1 - (offset * 0.003))
            }.frame(height: 44)
                .padding(.top, Size.safeArea().top)
        }
        .background(Color.gray10)
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }

    
    
    var TopView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("SLEEP_ENHANCER")
                    .font(semiBold22Font)
                Text("LIFESTYLE")
                    .tracking(-1)
                    .font(bold46Font)
            }
            .gradientForeground(colors: [.green100, .blue500], startPoint: .leading, endPoint: .trailing)
            .padding(.bottom, Size.w(60))
            
            Image("lifestyle-image1")
                .resizable()
                .scaledToFit()
                .frame(width: Size.w(374), height: Size.w(464))
                .padding(.bottom, Size.w(16))
            
            VStack(spacing: 0) {
                Text("READ_MORE")
                    .font(regular16Font)
                    .foregroundColor(.blue400)
                    .padding(.bottom, Size.w(140))
                
                Text("LIFESTYLE.T1")
                    .tracking(-1)
                    .font(semiBold24Font)
                    .foregroundColor(.blue400)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, Size.w(22))
                
                Text("LIFESTYLE.T2")
                    .font(regular16Font)
                    .foregroundColor(.blue400)
                    .lineSpacing(Size.w(5))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, Size.w(148))
                
                Text("LIFESTYLE.T3")
                    .tracking(-4)
                    .font(bold52Font)
                    .foregroundColor(.blue300).opacity(0.5)
                Text("LIFESTYLE.T4")
                    .tracking(-4)
                    .font(bold52Font)
                    .foregroundColor(.blue300).opacity(0.5)
                    .offset(y: Size.w(-20))
            }
            .padding(.horizontal, Size.w(30))
            
        }
        .padding(.bottom, Size.w(650))
    }
    
    var EveningView: some View {
        VStack(spacing: 0) {
            SunView
                .padding(.bottom, Size.w(60))
            
            Text("EVENING")
                .tracking(-1)
                .font(regular20Font)
                .foregroundColor(.blue50)
                .padding(.bottom, Size.w(10))
            
            Text("LIFESTYLE.T5")
                .tracking(-1)
                .font(semiBold24Font)
                .foregroundColor(.blue50)
                .padding(.bottom, Size.w(22))
            
            Text("LIFESTYLE.T6")
                .tracking(-1)
                .font(regular16Font)
                .foregroundColor(.green100)
                .padding(.bottom, Size.w(10))
            
            Text("LIFESTYLE.T7")
                .tracking(-0.5)
                .multilineTextAlignment(.center)
                .lineSpacing(Size.w(6))
                .font(regular16Font)
                .foregroundColor(.blue200)
                .padding(.bottom, Size.w(60))
            
            Text("LIFESTYLE.T8")
                .tracking(-1)
                .font(regular20Font)
                .foregroundColor(.blue50)
                .padding(.bottom, Size.w(10))
            
            Text("LIFESTYLE.T9")
                .tracking(-1)
                .font(semiBold24Font)
                .foregroundColor(.blue50)
                .padding(.bottom, Size.w(22))
            
            Text("LIFESTYLE.T10")
                .tracking(-1)
                .font(regular16Font)
                .foregroundColor(.green100)
                .padding(.bottom, Size.w(10))
            
            Text("LIFESTYLE.T11")
                .tracking(-0.5)
                .multilineTextAlignment(.center)
                .lineSpacing(Size.w(6))
                .font(regular16Font)
                .foregroundColor(.blue200)
                .padding(.bottom, Size.w(60))
            
        }
        .padding(.horizontal, Size.w(30))
        .padding(.bottom, Size.w(140))
    }
    
    
    var SunView: some View {
        ZStack {
            
            let width: CGFloat = Size.w(180)
            
            Circle()
                .fill(LinearGradient(colors: [
                    Color(red: 255/255, green: 187/255, blue: 0/255),
                    Color(red: 247/255, green: 143/255, blue: 46/255)
                ], startPoint: .top, endPoint: .bottom))
                .frame(width: Size.w(54), height: Size.w(54))
                .shadow(color: Color.yellow, radius: 25)
                .offset(y: Size.w(15))
            ZStack {
                HalfCircle()
                    .stroke(LinearGradient(colors: [
                        .white,
                        Color(red: 255/255, green: 255/255, blue: 214/255, opacity: 1),
                        Color(red: 255/255, green: 187/255, blue: 0/255, opacity: 0.6),
                        Color(red: 255/255, green: 187/255, blue: 0/255, opacity: 0.6),
                        Color(red: 255/255, green: 187/255, blue: 0/255, opacity: 0.6),
                        Color(red: 255/255, green: 187/255, blue: 0/255, opacity: 0.6),
                    ], startPoint: .top, endPoint: .bottom))
                    .opacity(0.8)
                Blur(style: .systemUltraThinMaterialLight, intensity: 0.2)
                    .clipShape(HalfCircle())
                    .shadow(radius: 30, y: 10)
            }
            .frame(width: width, height: width * 0.65)
            //            .rotationEffect(.degrees(180))
            .offset(y: Size.w(60))
        }
    }
    
    var NightView: some View {
        VStack(spacing: 0) {
            MoonView
                .padding(.bottom, Size.w(60))
            
            Text("LIFESTYLE.T12")
                .tracking(-1)
                .font(regular20Font)
                .foregroundColor(.blue50)
                .padding(.bottom, Size.w(10))
            
            Text("LIFESTYLE.T13")
                .tracking(-1)
                .font(semiBold24Font)
                .foregroundColor(.blue50)
                .padding(.bottom, Size.w(22))
            
            Text("LIFESTYLE.T14")
                .tracking(-1)
                .font(regular16Font)
                .foregroundColor(.green100)
                .padding(.bottom, Size.w(10))
            
            Text("LIFESTYLE.T15")
                .tracking(-0.5)
                .multilineTextAlignment(.center)
                .lineSpacing(Size.w(6))
                .font(regular16Font)
                .foregroundColor(.blue200)
                .padding(.bottom, Size.w(22))
            
            Text("LIFESTYLE.T16")
                .tracking(-1)
                .font(regular16Font)
                .foregroundColor(.green100)
                .padding(.bottom, Size.w(10))
            
            Text("LIFESTYLE.T17")
                .tracking(-0.5)
                .multilineTextAlignment(.center)
                .lineSpacing(Size.w(6))
                .font(regular16Font)
                .foregroundColor(.blue200)
                .padding(.bottom, Size.w(170))
        }
        .padding(.horizontal, Size.w(30))
    }
    
    var MoonView: some View {
        ZStack {
            let width: CGFloat = Size.w(180)
            
            Image("moon")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue200)
                .frame(width: Size.w(62), height: Size.w(60))
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
    
    var SleepView: some View {
        VStack(spacing: 0) {
            PillowView()
                .padding(.bottom, Size.w(60))
            
            Text("LIFESTYLE.T18")
                .tracking(-1)
                .font(regular20Font)
                .foregroundColor(.blue50)
                .padding(.bottom, Size.w(10))
            
            Text("LIFESTYLE.T19")
                .tracking(-1)
                .multilineTextAlignment(.center)
                .font(semiBold24Font)
                .foregroundColor(.blue50)
                .padding(.bottom, Size.w(22))
            
            Text("LIFESTYLE.T20")
                .tracking(-1)
                .font(regular16Font)
                .foregroundColor(.green100)
                .padding(.bottom, Size.w(10))
            
            Text("LIFESTYLE.T21")
                .tracking(-0.5)
                .multilineTextAlignment(.center)
                .lineSpacing(Size.w(6))
                .font(regular16Font)
                .foregroundColor(.blue200)
        }
        .padding(.horizontal, Size.w(30))
        .padding(.bottom, Size.w(40))
    }
    
    var MorningView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                MorningSunView
                    .padding(.bottom, Size.w(60))
                
                Text("MORNING")
                    .tracking(-1)
                    .font(regular20Font)
                    .foregroundColor(.green500)
                    .padding(.bottom, Size.w(10))
                
                Text("LIFESTYLE.T22")
                    .tracking(-1)
                    .font(semiBold24Font)
                    .foregroundColor(.green500)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, Size.w(22))
                
                Text("LIFESTYLE.T23")
                    .tracking(-1)
                    .font(regular16Font)
                    .foregroundColor(.green300)
                    .padding(.bottom, Size.w(10))
                
                Text("LIFESTYLE.T24")
                    .tracking(-0.5)
                    .multilineTextAlignment(.center)
                    .lineSpacing(Size.w(6))
                    .font(regular16Font)
                    .foregroundColor(.gray800)
                    .padding(.bottom, Size.w(-40))
            }
            .offset(y: Size.w(-120))
        }
        .padding(.horizontal, Size.w(30))
        .background(Color.white)
        
    }
    
    var MorningSunView: some View {
        ZStack {
            
            let width: CGFloat = Size.w(180)
            
            Circle()
                .fill(LinearGradient(colors: [
                    Color(red: 255/255, green: 187/255, blue: 0/255),
                    Color(red: 247/255, green: 143/255, blue: 46/255)
                ], startPoint: .top, endPoint: .bottom))
                .frame(width: Size.w(54), height: Size.w(54))
                .shadow(color: Color.yellow, radius: 25)
                .offset(y: Size.w(15))
            ZStack {
                HalfCircle()
                    .stroke(LinearGradient(colors: [
                        .white,
                        Color(red: 255/255, green: 255/255, blue: 214/255, opacity: 1),
                        Color(red: 255/255, green: 187/255, blue: 0/255, opacity: 0.6),
                        Color(red: 255/255, green: 187/255, blue: 0/255, opacity: 0.6),
                        Color(red: 255/255, green: 187/255, blue: 0/255, opacity: 0.6),
                        Color(red: 255/255, green: 187/255, blue: 0/255, opacity: 0.6),
                    ], startPoint: .top, endPoint: .bottom))
                    .opacity(0.8)
                Blur(style: .systemUltraThinMaterialLight, intensity: 0.2)
                    .clipShape(HalfCircle())
                    .shadow(color: Color(red: 255/255, green: 187/255, blue: 0/255, opacity: 0.3), radius: 30, y: 10)
                
            }
            .frame(width: width, height: width * 0.65)
            .rotationEffect(.degrees(180))
            .offset(y: Size.w(40))
        }
    }
    
    var MorningInsightsView: some View {
        VStack(spacing: 0) {
            Image("lifestyle-bg2")
                .resizable()
                .scaledToFit()
                .frame(width: Size.w(375), height: Size.w(300))
            
            VStack(spacing: 0) {
                InsightsShape
                
                VStack(spacing: 0) {
                    Text("LIFESTYLE.T25")
                        .tracking(-1)
                        .font(regular20Font)
                        .foregroundColor(.green500)
                        .padding(.bottom, Size.w(10))
                    Text("LIFESTYLE.T26")
                        .tracking(-1)
                        .font(semiBold24Font)
                        .foregroundColor(.green500)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, Size.w(22))
                    
                    Text("LIFESTYLE.T27")
                        .tracking(-1)
                        .font(regular16Font)
                        .foregroundColor(.green300)
                        .padding(.bottom, Size.w(10))
                    
                    Text("LIFESTYLE.T28")
                        .tracking(-0.5)
                        .multilineTextAlignment(.center)
                        .lineSpacing(Size.w(6))
                        .font(regular16Font)
                        .foregroundColor(.gray800)
                        .padding(.bottom, Size.w(40))
                }
                .padding(.horizontal, Size.w(30))
                .padding(.top, Size.w(-60))
            }
            .background(Color.white)
        }
    }
    
    var InsightsShape: some View {
        ZStack {
            ZStack {
                ArrowUpShape()
                    .stroke(LinearGradient(colors: [
                        .white,
                        Color(red: 221/255, green: 255/255, blue: 250/255),
                        Color(red: 7/255, green: 181/255, blue: 236/255).opacity(0.6)
                    ], startPoint: .top, endPoint: .bottom), lineWidth: 1)
                ArrowUpShape()
                    .fill(LinearGradient(colors: [
                        Color(red: 59/255, green: 255/255, blue: 229/255),
                        Color(red: 106/255, green: 221/255, blue: 255/255),
                        Color(red: 11/255, green: 141/255, blue: 255/255),
                        Color(red: 0/255, green: 102/255, blue: 255/255)
                    ], startPoint: .top, endPoint: .bottom))
            }
            .frame(width: Size.w(54), height: Size.w(80))
            .offset(y: Size.w(10))
            .frame(width: Size.w(120), height: Size.w(120), alignment: .top)
            .shadow(color: Color(red: 106/255, green: 221/255, blue: 255/255).opacity(0.3), radius: 30, y: 10)
            
            ZStack {
                Trapezoid()
                    .stroke(LinearGradient(colors: [
                        .white,
                        Color(red: 236/255, green: 246/255, blue: 255/255),
                        Color(red: 121/255, green: 192/255, blue: 255/255).opacity(0.6)
                    ], startPoint: .top, endPoint: .bottom), lineWidth: 1)
                Blur(intensity: 0.3)
                    .clipShape(Trapezoid())
                    .shadow(color: Color(red: 106/255, green: 221/255, blue: 255/255).opacity(0.3), radius: 30, y: 10)
            }
            .frame(width: Size.w(120), height: Size.w(46))
            .frame(width: Size.w(120), height: Size.w(120), alignment: .bottom)
        }
        .offset(y: Size.w(-100))
    }
    
    var BottomView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Image("wethm-logo-large")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Size.w(94), height: Size.w(74))
                    .padding(.top, Size.w(140))
                    .padding(.bottom, Size.w(40))
                
                Text("LIFESTYLE.T29")
                    .tracking(-1)
                    .font(regular20Font)
                    .foregroundColor(.blue50)
                    .padding(.bottom, Size.w(10))
                Text("LIFESTYLE.T30")
                    .tracking(-1)
                    .font(semiBold24Font)
                    .foregroundColor(.blue50)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, Size.w(22))
                
                Text("LIFESTYLE.T31")
                    .tracking(-1)
                    .font(regular16Font)
                    .foregroundColor(.green100)
                    .padding(.bottom, Size.w(12))
                
                Text("LIFESTYLE.T32")
                    .tracking(-0.5)
                    .multilineTextAlignment(.center)
                    .lineSpacing(Size.w(6))
                    .font(regular16Font)
                    .foregroundColor(.blue200)
                    .padding(.bottom, Size.w(140))
                
                NotesView
                    .padding(.bottom, Size.w(40))
                
                Text("LIFESTYLE.T33")
                    .tracking(-1)
                    .font(regular20Font)
                    .foregroundColor(.blue50)
                    .padding(.bottom, Size.w(10))
                Text("LIFESTYLE.T34")
                    .tracking(-1)
                    .font(semiBold24Font)
                    .foregroundColor(.blue50)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, Size.w(22))
                
                Text("LIFESTYLE.T35")
                    .tracking(-1)
                    .font(regular16Font)
                    .foregroundColor(.green100)
                    .padding(.bottom, Size.w(12))
                
                Text("LIFESTYLE.T36")
                    .tracking(-0.5)
                    .multilineTextAlignment(.center)
                    .lineSpacing(Size.w(6))
                    .font(regular16Font)
                    .foregroundColor(.blue200)
                    .padding(.bottom, Size.w(140))
            }
            .padding(.horizontal, Size.w(30))
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(colors: [
            Color(red: 16/255, green: 40/255, blue: 129/255),
            Color(red: 42/255, green: 100/255, blue: 246/255)
        ], startPoint: .top, endPoint: .bottom))
        
    }
    
    var NotesView: some View {
        ZStack {
            Image("three-notes")
                .resizable()
                .scaledToFit()
                .frame(width: Size.w(95), height: Size.w(76))
                .frame(width: Size.w(120), height: Size.w(120), alignment: .center)
                .offset(y: Size.w(-10))
            
            ZStack {
                Trapezoid()
                    .stroke(LinearGradient(colors: [
                        Color(red: 121/255, green: 192/255, blue: 255/255).opacity(0.6),
                        Color(red: 236/255, green: 246/255, blue: 255/255),
                        .white
                    ], startPoint: .top, endPoint: .bottom), lineWidth: 1)
                Blur(intensity: 0.3)
                    .clipShape(Trapezoid())
                    .shadow(color: Color(red: 106/255, green: 221/255, blue: 255/255).opacity(0.3), radius: 30, y: 10)
            }
            .frame(width: Size.w(120), height: Size.w(46))
            .rotationEffect(.degrees(180))
            .frame(width: Size.w(120), height: Size.w(120), alignment: .bottom)
        }
    }
    
}


struct Trapezoid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.99334*width, y: 0.82672*height))
        path.addCurve(to: CGPoint(x: 0.94448*width, y: height), control1: CGPoint(x: 1.00503*width, y: 0.91148*height), control2: CGPoint(x: 0.98008*width, y: height))
        path.addLine(to: CGPoint(x: 0.05551*width, y: height))
        path.addCurve(to: CGPoint(x: 0.00666*width, y: 0.82672*height), control1: CGPoint(x: 0.01993*width, y: height), control2: CGPoint(x: -0.00503*width, y: 0.91148*height))
        path.addLine(to: CGPoint(x: 0.10861*width, y: 0.08758*height))
        path.addCurve(to: CGPoint(x: 0.15746*width, y: 0), control1: CGPoint(x: 0.11584*width, y: 0.03515*height), control2: CGPoint(x: 0.13545*width, y: 0))
        path.addLine(to: CGPoint(x: 0.84254*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.89139*width, y: 0.08758*height), control1: CGPoint(x: 0.86455*width, y: 0), control2: CGPoint(x: 0.88416*width, y: 0.03515*height))
        path.addLine(to: CGPoint(x: 0.99334*width, y: 0.82672*height))
        path.closeSubpath()
        return path
    }
}

struct LifestyleGuideView_Previews: PreviewProvider {
    static var previews: some View {
        LifestyleGuideView()
    }
}
