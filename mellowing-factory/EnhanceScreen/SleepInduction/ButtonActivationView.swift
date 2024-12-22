//
//  ButtonActivationView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/04/05.
//

import SwiftUI

struct ButtonActivationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var deviceManager: DeviceManager
    
    @State var isLoading = false
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("BUTTON_ACTIVATION")
                    .font(semiBold18Font)
                    .foregroundColor(.gray500)
                    .padding(.leading, Size.w(10))
                Spacer()
                
                if isLoading {
                    ProgressView().frame(width: Size.w(56), height: Size.h(32), alignment: .center)
                }
                    ToggleView(isOn: $deviceManager.sleepInductionState.isManual, width: 56, action: {
                        self.isLoading = true
                        deviceManager.updateState(isManual: deviceManager.sleepInductionState.isManual) { _ in
                            self.isLoading = false
                        }
                    }) {}.frame(width: Size.w(56), height: Size.w(32))
                
            }
            .padding(.horizontal, Size.w(20))
            .padding(.vertical, Size.w(22))
            .background(Color.white)
            .cornerRadius(14)
            .padding(.bottom, Size.h(16))
            .padding(.top, Size.h(32))
      
            Text("ENH.BTN.DESC")
                .font(regular14Font)
                .foregroundColor(.gray300)
                .padding(.horizontal, Size.w(14))
                
            Spacer()
        }.padding(.horizontal, Size.w(16))
        .navigationView(back: back, title: "BUTTON_ACTIVATION", bg: LinearGradient(colors: [Color.gray10], startPoint: .bottom, endPoint: .top))
        .onChange(of: vc.refreshEnhanceScreen) { _ in
            back()
        }
    }
    
    private func back() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ButtonActivationView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonActivationView()
    }
}
