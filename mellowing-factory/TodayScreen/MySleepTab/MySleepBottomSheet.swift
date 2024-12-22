//
//  BottomSheet.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/01/30.
//

import SwiftUI

struct MySleepBottomSheet: View {
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var msc: MainScreenController
    
    @Binding var offset: CGFloat
    @State var lastOffset: CGFloat = 0
    @State var infoPresented: Bool = false
    @GestureState var gestureOffset: CGFloat = 0
    
    let small: CGFloat =  Size.h(166)
    
    var body: some View {
        ZStack {
            GeometryReader { proxy -> AnyView in
                let height = proxy.frame(in: .global).height
                return AnyView(
                    ZStack {
                        Color.white
                            .clipShape(RoundedCorner(radius: 25, corners: [.topLeft, .topRight]))
                            .shadow(color: .blue100.opacity(msc.details ?  0 : 0.3), radius: 10)
                        
                        VStack(spacing: 0) {
                            VStack(spacing: 0) {
                                header
                                SleepDebtView()
                                SleepVitalsEnvView()
                            }
                            Spacer()
                        }.padding(.horizontal, Size.h(16))
                            .padding(.vertical, Size.h(28))
                    }
                        .offset(y: height - small)
                        .offset(y: -offset > 0 ? -offset <= (height - small) ? offset : -(height - small) : 0)
                        .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                            out = value.translation.height
                            onChange()
                        }).onEnded({ value in
                            onEndDragGesture(height: height)
                        }))
                        .onTapGesture {
                            let maxHeight = height - small
                            withAnimation {
                                if !msc.details {
                                    offset = -maxHeight
                                    lastOffset = offset
                                    msc.details.toggle()
                                }
                            }
                        }
                )
            }.ignoresSafeArea(.all, edges: .bottom)
        }
        .sheetWithDetents(isPresented: $infoPresented, onDismiss: { }) {
            ContentInfoSheet(type: .attributes)
        }
        .onReceive(vc.$refreshTodayScreen) { _ in
            withAnimation {
                offset = 0
                lastOffset = offset
                msc.details = false
            }
        }
        
    }
    
    
    var header: some View {
        HStack {
            Text("TODAY.ATTRIBUTES")
                .font(semiBold18Font)
                .foregroundColor(.gray1000)
            Spacer()
            Button(action: {
                infoPresented = true
            }) {
                Image("information")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray300)
                    .frame(width: Size.w(18), height: Size.h(18))
            }
        }.padding(.horizontal, Size.h(6))
            .padding(.bottom, Size.h(13))
    }
    
    private func onEndDragGesture(height: CGFloat) {
        let maxHeight = height - small
        withAnimation {
            if msc.details {
                if -offset < maxHeight * 0.9 {
                    msc.details = false
                    offset = 0
                } else {
                    msc.details = true
                    offset = -maxHeight
                }
            } else {
                if -offset > maxHeight * 0.1 {
                    msc.details = true
                    offset = -maxHeight
                } else {
                    msc.details = false
                    offset = 0
                }
            }
        }
        
        // Storing Last Offset...
        // So that the gesture can contine from the last position....
        lastOffset = offset
    }
    
    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
}

struct MySleepBottomSheet_Previews: PreviewProvider {
    static let vc = ContentViewController()
    static let msc = MainScreenController()
    static var previews: some View {
        NavigationView {
            MySleepBottomSheet(offset: .constant(0))
                .environmentObject(vc)
                .environmentObject(msc)
        }
    }
}
