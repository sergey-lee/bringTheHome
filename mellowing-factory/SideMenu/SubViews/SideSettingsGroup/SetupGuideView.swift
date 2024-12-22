//
//  SetupGuideView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/07/04.
//

import SwiftUI

struct SetupGuideView: View {
    enum bedOption: String {
        case single, couple
    }
    
    enum bedSize: String {
        case small, twin, queen, king
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var option: bedOption = .single
    @State var size: bedSize = .small
    @State var animation = false
    @State var offset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                Color.gray1100
                Color.gray800
            }
            .frame(maxWidth: .infinity)
            TrackableScrollView(showIndicators: false, contentOffset: $offset) {
                ZStack(alignment: .top) {
                    VStack(spacing: 0) {
                        ZStack(alignment: .top) {
                            Image("setup-guide-bg1")
                                .resizable()
                                .scaledToFit()

                            VStack(spacing: 0) {
                                VStack(spacing: 0) {
                                    Text("SLEEP_ENHANCER")
                                        .font(semiBold22Font)
                                    Text("SETUP_GUIDE.T1")
                                        .tracking(-1)
                                        .font(bold46Font)
                                }
                                .gradientForeground(colors: [.green100, .blue500], startPoint: .leading, endPoint: .trailing)

                                Image("setup-guide-image1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: Size.w(227), height: Size.w(491))
                                    .padding(.bottom, Size.w(16))

                                Text("READ_MORE")
                                    .font(regular16Font)
                                    .foregroundColor(.blue400)
                                    .padding(.bottom, Size.w(160))

                                Text("WELCOME")
                                    .font(semiBold24Font)
                                    .foregroundColor(.blue400)
                                    .padding(.bottom, Size.w(22))

                                Text("SETUP_GUIDE.T2")
                                    .font(regular16Font)
                                    .foregroundColor(.blue400)
                                    .lineSpacing(Size.w(5))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, Size.w(22))
                                    .padding(.bottom, Size.w(220))

                                Text("SETUP_GUIDE.T3")
                                    .tracking(-4)
                                    .font(bold52Font)
                                    .foregroundColor(.blue300).opacity(0.5)
                                Text("SETUP_GUIDE.T4")
                                    .tracking(-4)
                                    .font(bold52Font)
                                    .foregroundColor(.blue300).opacity(0.5)
                                    .offset(y: Size.w(-20))
                            }
                            .padding(.top, 44 + 50)
                            .padding(.top, Size.safeArea().top)
                        }
                        
                        VStack(spacing: 0) {
                            VStack(spacing: 0) {
                              ComponentsView

                                Text("STEP_01")
                                    .font(bold32Font)
                                    .foregroundColor(.gray1100)
                                    .padding(.bottom, Size.w(20))
                                Text("SETUP_GUIDE.T8")
                                    .font(regular16Font)
                                    .foregroundColor(.gray800)
                                    .lineSpacing(Size.w(6))
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal, Size.w(22))
                                    .padding(.bottom, Size.w(20))

                                Image("device-connect")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray1100)
                                    .frame(width: Size.w(375), height: Size.w(340))
                                
                                Text("SETUP_GUIDE.T9")
                                    .font(regular16Font)
                                    .foregroundColor(.gray800)
                                    .padding(.horizontal, Size.w(22))
                                    .padding(.bottom, 5)
                                Text("SETUP_GUIDE.T10")
                                    .font(regular16Font)
                                    .foregroundColor(.blue500)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal, Size.w(22))
                                    .padding(.bottom, Size.w(20))

                                ZStack {
                                    Image("device-power")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray1100)
                                        .frame(width: Size.w(375))
                                    Circle()
                                        .fill(Color.green200)
                                        .frame(width: Size.w(10), height: Size.w(10))
                                        .blur(radius: 3.5)
                                        .offset(x: Size.w(-38), y: Size.w(3))
                                        .opacity(1)
                                }
                                .frame(width: Size.w(375), height: Size.w(340))
                                .padding(.bottom, Size.w(160))
                            }

                            
                            Text("STEP_02")
                                .font(bold32Font)
                                .foregroundColor(.gray1100)
                                .padding(.bottom, Size.w(20))
                            Text("SETUP_GUIDE.T11")
                                .font(regular16Font)
                                .foregroundColor(.gray800)
                                .lineSpacing(Size.w(6))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, Size.w(22))
                                .padding(.bottom, Size.w(20))
                            Text("SETUP_GUIDE.T12")
                                .font(regular16Font)
                                .foregroundColor(.blue500)
                                .lineSpacing(Size.w(6))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, Size.w(22))
                                .padding(.bottom, Size.w(20))

                            Image("device-on-bed")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray1100)
                                .padding(.bottom, Size.w(160))
                            
                            VStack(spacing: 0) {
                                Text("STEP_03")
                                    .font(bold32Font)
                                    .foregroundColor(.gray1100)
                                    .padding(.bottom, Size.w(20))
                                Text("SETUP_GUIDE.T13")
                                    .font(regular16Font)
                                    .foregroundColor(.gray800)
                                    .lineSpacing(Size.w(6))
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal, Size.w(22))
                                    .padding(.bottom, Size.w(20))
                                Text("SETUP_GUIDE.T14")
                                    .font(regular16Font)
                                    .foregroundColor(.blue500)
                                    .lineSpacing(Size.w(6))
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal, Size.w(22))
                                    .padding(.bottom, Size.w(20))

                                Image("bluetooth-connect")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray1100)
                                    .padding(.bottom, Size.w(160))


                                Text("STEP_04")
                                    .font(bold32Font)
                                    .foregroundColor(.gray1100)
                                    .padding(.bottom, Size.w(20))
                                Text("SETUP_GUIDE.T15")
                                    .font(regular16Font)
                                    .foregroundColor(.gray800)
                                    .lineSpacing(Size.w(6))
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal, Size.w(22))
                                    .padding(.bottom, Size.w(20))
                                Text("SETUP_GUIDE.T16")
                                    .font(regular16Font)
                                    .foregroundColor(.blue500)
                                    .lineSpacing(Size.w(6))
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal, Size.w(22))


                                ZStack {
                                    Image("setup-guide-image-devices")
                                        .resizable()
                                        .scaledToFit()

                                    Circle()
                                        .fill(Color.green200)
                                        .frame(width: Size.w(10), height: Size.w(10))
                                        .blur(radius: 3.5)
                                        .offset(x: Size.w(-118), y: Size.w(2))
                                        .opacity(animation ? 0 : 1)
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                withAnimation(.linear(duration: 0.25).repeatForever(autoreverses: true)) {
                                                    self.animation = true
                                                }
                                            }
                                        }

                                    Circle()
                                        .fill(Color.green200)
                                        .frame(width: Size.w(10), height: Size.w(10))
                                        .blur(radius: 2)
                                        .offset(x: Size.w(63), y: Size.w(2))
                                        .opacity(0.3)
                                }
                                .frame(width: Size.w(375), height: Size.w(340))
                                .padding(.bottom, Size.w(40))
                            }
                        }
                        .background(Color.gray10)
                        
                        VStack(alignment: .center, spacing: Size.h(20)) {
                            Text("SETUP_GUIDE.BED.TITLE")
                                .foregroundColor(.white)
                                .font(bold32Font)
                                .multilineTextAlignment(.center)
                                .padding(.top, Size.h(100))
                            Text("SETUP_GUIDE.BED.HINT")
                                .foregroundColor(.gray200)
                                .font(regular16Font)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, Size.h(20))
                            
                            switcher
                                .padding(.bottom, Size.h(40))
                            
                            
                            Image("guide-bed-\(option.rawValue)-\(size.rawValue)")
                                .resizable()
                                .scaledToFit()
                                .onTapGesture(perform: switching)
                                .padding(.bottom, Size.h(10))
                            
                            VStack(alignment: .leading, spacing: Size.w(12)) {
                                Text("SETUP_GUIDE.BED.SIZE")
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(.gray400)
                                    .font(regular16Font)
                                
                                HStack {
                                    Color.green200.frame(width: Size.w(12), height: Size.w(12))
                                    Text("SLEEP_ENHANCER")
                                    Spacer()
                                    Text("33.86” x 3.54”")
                                }
                                .font(regular14Font)
                                .foregroundColor(.gray200)
                                
                                if option == .single {
                                    Button(action: {
                                        withAnimation {
                                            size = .small
                                        }
                                    }) {
                                        HStack {
                                            Color.blue100.frame(width: Size.w(12), height: Size.w(12))
                                            Text("SMALL_SINGLE")
                                            Spacer()
                                            Text("30” x 75”")
                                        }
                                        .font(size == .small ? bold14Font : regular14Font)
                                        .foregroundColor(size == .small ? .white : .gray200)
                                    }
                                    
                                    Button(action: {
                                        withAnimation {
                                            size = .twin
                                        }
                                    }) {
                                        HStack {
                                            Color.blue200.frame(width: Size.w(12), height: Size.w(12))
                                            Text("TWIN")
                                            Spacer()
                                            Text("38” x 75”")
                                        }
                                        .font(size == .twin ? bold14Font : regular14Font)
                                        .foregroundColor(size == .twin ? .white : .gray200)
                                    }
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        size = .queen
                                    }
                                }) {
                                    HStack {
                                        Color.blue300.frame(width: Size.w(12), height: Size.w(12))
                                        Text("QUEEN")
                                        Spacer()
                                        Text("60” x 80”")
                                    }
                                    .font(size == .queen ? bold14Font : regular14Font)
                                    .foregroundColor(size == .queen ? .white : .gray200)
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        size = .king
                                    }
                                }) {
                                    HStack {
                                        Color.blue400.frame(width: Size.w(12), height: Size.w(12))
                                        Text("KING")
                                        Spacer()
                                        Text("76” x 80”")
                                    }
                                    .font(size == .king ? bold14Font : regular14Font)
                                    .foregroundColor(size == .king ? .white : .gray200)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, Size.h(200))
                           
                        }
                        .padding(.horizontal, Size.w(22))
                        .frame(maxWidth: .infinity)
                        .background(Color.gray800)
                    }.frame(maxWidth: .infinity)
                }
            }
        
            ZStack {
                Image("wethm-logo-text")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: Size.w(70), height: Size.h(16))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .opacity(1 - (offset * 0.003))
                
                BackButton(action: {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }, color: .gray500)
                .frame(width: 44, height: 44)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 44)
            .padding(.top, Size.safeArea().top)
        }
        .background(Color.gray10)
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    
    var ComponentsView: some View {
        VStack(spacing: 0) {
            Text("COMPONENT")
                .font(bold32Font)
                .foregroundColor(.gray1100)
                .padding(.bottom, Size.w(20))
            Text("SETUP_GUIDE.T5")
                .font(regular16Font)
                .foregroundColor(.gray800)
                .lineSpacing(Size.w(6))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, Size.w(22))
            
            ZStack {
                Image("setup-guide-image2")
                    .resizable()
                    .scaledToFit()
                Text("CONTROLLER")
                    .offset(x: Size.w(-80), y: Size.w(20))
                Text("SETUP_GUIDE.T6")
                    .multilineTextAlignment(.center)
                    .offset(x: Size.w(65), y: Size.w(27))
                Text("SETUP_GUIDE.T7")
                    .offset(x: Size.w(-30), y: Size.w(180))
            }
            .font(regular12Font)
            .foregroundColor(.gray600)
            .frame(width: Size.w(375), height: Size.w(400))
            .padding(.bottom, Size.w(160))
        }
    }
    
    var switcher: some View {
        HStack(spacing: 0) {
            Button(action: {
                withAnimation {
                    self.option = .single
                }
            }) {
                Text("SINGLE")
                    .font(regular18Font)
                    .foregroundColor(.white)
                    .padding(.vertical, 11)
                    .frame(maxWidth: .infinity, alignment: .center)
                
            }
            
            .background(Color.white.opacity(option == .single ? 0.1 : 0))
            .cornerRadius(25, corners: [.topLeft, .bottomLeft])
            
            //            Color.white.opacity(0.3).frame(width: 2, height: .infinity)
            Color.gray500.frame(width: 2, height: .infinity)
            
            Button(action: {
                withAnimation {
                    if self.size == .small || self.size == .twin {
                        self.size = .queen
                    }
                    self.option = .couple
                }
            }) {
                Text("COUPLE")
                    .font(regular18Font)
                    .foregroundColor(.white)
                    .padding(.vertical, 11)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .background(Color.white.opacity(option == .couple ? 0.1 : 0))
            .cornerRadius(25, corners: [.topRight, .bottomRight])
            
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .clipShape(Rectangle())
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.gray500, lineWidth: 2)
            //                .stroke(Color.white.opacity(0.4), lineWidth: 2)
                .frame(height: 44)
        )
    }
    
    private func switching() {
        withAnimation {
            switch option {
            case .single:
                switch size {
                case .small:
                    self.size = .twin
                case .twin:
                    self.size = .queen
                case .queen:
                    self.size = .king
                case .king:
                    self.size = .small
                }
            case .couple:
                switch size {
                case .queen:
                    self.size = .king
                default:
                    self.size = .queen
                }
            }
        }
    }
}

struct SetupGuideView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SetupGuideView()
                .navigationBarHidden(true)
        }
    }
}
