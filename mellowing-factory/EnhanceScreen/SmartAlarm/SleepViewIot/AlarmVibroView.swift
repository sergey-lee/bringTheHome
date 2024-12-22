//
//  AlarmVibroView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/04/07.
//

import SwiftUI

struct AlarmVibroView: View {
    @EnvironmentObject var deviceManager: DeviceManager
    
    @Binding var mode: Int
    @Binding var value: CGFloat
    @Binding var endValue: CGFloat
    @Binding var isSnoozeOn: Bool
    
    @State var selectionPresented = false
    
    var body: some View {
        VStack(spacing: 0) {
//            NavigationLink(destination: {
//                VibrationModeSelectionView(mode: $mode, endValue: $endValue)
//            }) {
                
                Button(action: {
                    selectionPresented = true
                }) {
            HStack(alignment: .center) {
                Text("PATTERNS")
                    .foregroundColor(.gray500)
                    .font(regular18Font)
                Spacer()
//                Menu {
//                    ForEach(1..<8) { index in
//                        Button {
//                            withAnimation(.spring()) {
//                                mode = index
//                            }
//                        } label: {
//                            Label(vibrationTypes[index], systemImage: mode == index ? "checkmark" : "")
//                        }
//                    }
//                } label: {
                
                    HStack {
                        Image("ic-wave")
                            .resizable()
                            .scaledToFit()
                            .frame(width: Size.w(18), height: Size.h(18))
                        Text(vibrationTypes[mode])
                            .tracking(-1)
                            .foregroundColor(.gray400)
                            .font(regular16Font)
                            .fixedSize()
                        Image("chevron-up")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray300)
                            .frame(width: Size.w(18), height: Size.h(18))
                            .rotationEffect(.degrees(90))
                    }.animation(.easeIn, value: mode)
                }
            }
            .padding(.horizontal, Size.w(10))
            .padding(.vertical, Size.w(19))
            
            Divider()
            
            HStack(alignment: .center, spacing: Size.w(10)) {
                Image("ic-vibration-low")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Size.w(18), height: Size.w(18))
                CustomSlider(value: $value, endValue: $endValue, enabled: .constant(true), range: 4...10)
                    .onChange(of: endValue) { value in
                        deviceManager.testVibration(mode: mode, strength: Int(value)) { _ in }
                    }
                Image("ic-vibration-high")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Size.w(18), height: Size.w(18))
            }
            .padding(.horizontal, Size.w(10))
            .padding(.vertical, Size.w(19))
            
            Divider()

            HStack {
                Text("SNOOZE")
                    .foregroundColor(.gray500)
                    .font(regular18Font)
                Spacer()
                ToggleView(isOn: $isSnoozeOn, width: 56) {}
                    .frame(width: Size.w(56), height: Size.w(32))
            }
            .padding(.horizontal, Size.w(10))
            .padding(.vertical, Size.w(19))
            
        }
        .padding(.horizontal, Size.w(14))
        .padding(.vertical, Size.w(2))
        .background(Color.white)
        .cornerRadius(Size.w(14))
        .sheet(isPresented: $selectionPresented) {
            VibrationModeSelectionView(mode: $mode, endValue: $endValue)
        }
    }
}

struct AlarmVibroView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            AlarmVibroView(mode: .constant(1), value: .constant(7), endValue: .constant(7), isSnoozeOn: .constant(true))
            Spacer()
        }.background(Color.gray500)
        
    }
}
//        NavigationLink(destination: {
//            VibrationModeSelectionView(mode: $mode)
//        }) {
