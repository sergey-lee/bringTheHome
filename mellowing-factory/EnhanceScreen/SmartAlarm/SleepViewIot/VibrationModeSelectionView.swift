//
//  VibrationModeSelectionView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/04/06.
//

import SwiftUI

struct VibrationModeSelectionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var deviceManager: DeviceManager
    
    @Binding var mode: Int
    @Binding var endValue: CGFloat
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("PATTERNS")
                .foregroundColor(.gray700)
                .font(semiBold17Font)
                .padding(.vertical, Size.h(22))
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center, spacing: 0) {
                    ForEach(1..<8) { index in
                        Button(action: {
                            mode = index
                            deviceManager.testVibration(mode: mode, strength: Int(endValue)) {_ in }
                        }) {
                            HStack {
                                Text(vibrationTypes[index])
                                    .font(regular16Font)
                                    .foregroundColor(.gray500)
                                Spacer()
                                Image("ic-checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray300)
                                    .frame(width: Size.w(18), height: Size.w(18))
                                    .opacity(mode == index ? 1 : 0)
                            }
                            .padding(.vertical, Size.h(20))
                            .padding(.horizontal, Size.h(24))
                        }
                        
                        if index != 7 {
                            Divider()
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(Size.w(14))
                .padding(.horizontal, Size.h(22))
                .padding(.top, Size.h(22))
                .padding(.bottom, Size.h(12))
                
                Text("ENH.PATTERNS.HINT")
                    .foregroundColor(.gray300)
                    .font(regular14Font)
                    .padding(.horizontal, Size.w(36))
                
                Spacer().frame(height: 100)
            }
            //        .navigationView(back: back,title: "Patterns", bg: LinearGradient(colors: [Color.gray10], startPoint: .bottom, endPoint: .top))
        }
        .background(Color.gray10.ignoresSafeArea())
        .onDisappear {
            deviceManager.stopVibration {_ in }
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct VibrationModeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        VibrationModeSelectionView(mode: .constant(1), endValue: .constant(1))
    }
}
