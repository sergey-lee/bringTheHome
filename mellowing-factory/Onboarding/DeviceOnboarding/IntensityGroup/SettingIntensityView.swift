//
//  SettingIntensityView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/23.
//

import SwiftUI

struct SettingIntensityView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var animation = false
    @State var animation2 = false
    @State var stopped = false
    @State var stoppedAnimation = false
    @State var goToAlarmSetup = false
    
    var body: some View {
        ZStack {
            AnimatedBG(image: "lights3-bg").ignoresSafeArea()
            
            Text(stopped ? "DEVCICE_ONB.TITLE24" : "DEVCICE_ONB.TITLE25")
                .font(light18Font)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(7)
                .padding(.top, Size.h(74))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .top)
            
            ZStack {
                ZStack {
                    Circle()
                        .stroke(LinearGradient(colors: [.white, .white, .green100, .green100, .blue200, .blue200], startPoint: .top, endPoint: .bottom), style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        .frame(width: Size.w(544), height: Size.w(544))
                        .opacity(0.5)
                    
                    ZStack {
                        Circle()
                            .stroke(LinearGradient(colors: [.white, .white, .green100, .green100, .blue200, .blue200], startPoint: .top, endPoint: .bottom), lineWidth: stopped ? 2 : (animation ? 3 : 1))
                            .frame(width: Size.w(stopped ? (stoppedAnimation ? 260 : 264) : (animation ? 100 : 544)), height: Size.w(stopped ? (stoppedAnimation ? 260 : 264) : (animation ? 100 : 544)))
                            .opacity(animation2 ? 0 : 0.5)
                        
                        if !stopped {
                            Circle()
                                .stroke(LinearGradient(colors: [.white, .white, .green100, .green100, .blue200, .blue200], startPoint: .top, endPoint: .bottom), lineWidth: 5)
                                .frame(width: Size.w(544), height: Size.w(544))
                                .offset(x: Size.w(animation ? 100: 00), y: Size.w(animation ? -500 : -200))
                                .frame(width: Size.w(200), height: Size.w(200))
                                .clipShape(Circle())
                        }
                    }
                }
                Button(action: {
                    if stopped {
                        goToAlarmSetup = true
                    } else {
                        withAnimation(.interpolatingSpring(stiffness: 200, damping: 20)) {
                            stopped = true
                        }
                    }
                    
                }) {
                    ZStack {
                        Blur(intensity: stopped ? 0.6 : 0.3)
                            .clipShape(Circle())
                            .brightness(stopped ? 0 : (animation2 ? 0.05 : 0))
                            .shadow(color: .white.opacity(0.5), radius: stopped ? 0 : (animation2 ? 30 : 0))
                        Circle()
                            .stroke(LinearGradient(colors: [.white, .green100, .blue200, .blue400, .blue400, .blue400, .clear], startPoint: .top, endPoint: .bottom), lineWidth: 3)
                            .opacity(0.2)
                        Text(stopped ? "DEVCICE_ONB.SAVE" : "DEVCICE_ONB.STOP")
                            .font(bold30Font)
                            .foregroundColor(.white)
                    }.frame(width: Size.w(200), height: Size.w(200))
                }.overlay(
                    Button(action: {
                        withAnimation(.interpolatingSpring(stiffness: 200, damping: 20)) {
                            stopped = false
                        }
                    }) {
                        Text("DEVCICE_ONB.TRY")
                            .font(regular16Font)
                            .foregroundColor(.white)
                            .underline()
                    }.offset(y: Size.h(77))
                        .opacity(stopped ? 1 : 0)
                    , alignment: .bottom
                )
            }
            .padding(.top, Size.h(74))
            .clipped()
            
            NavigationLink(isActive: $goToAlarmSetup, destination: {
                AlarmSetupView()
            }) {
                EmptyView()
            }
        }
        .navigationView(backButtonHidden: true)
        .navigationBarItems(trailing: Button(action: back) {
            Text("CANCEL")
                .font(medium16Font)
                .foregroundColor(.gray100)
        })
        .onChange(of: stopped) { stopped in
            if stopped {
                self.animation = false
                self.animation2 = false
                withAnimation(.linear(duration: 0.1).repeatForever(autoreverses: true)) {
                    stoppedAnimation = true
                }
            } else {
                stoppedAnimation = false
                withAnimation(.easeIn(duration: 5).repeatForever(autoreverses: false)
                ){
                    self.animation = true
                }
                withAnimation(.easeIn(duration: 1).delay(4).repeatForever(autoreverses: false)
                ){
                    self.animation2 = true
                }
            }
        }
        
        .onAppear {
            // TODO: add intensity setup process here
            DispatchQueue.main.async {
                withAnimation(.easeIn(duration: 5).repeatForever(autoreverses: false)
                ){
                    self.animation = true
                }
                withAnimation(.easeIn(duration: 1).delay(4).repeatForever(autoreverses: false)
                ){
                    self.animation2 = true
                }
            }
        }
    }
    
    private func back() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingIntensityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingIntensityView()
                .navigationTitle("asdf")
        }
    }
}
