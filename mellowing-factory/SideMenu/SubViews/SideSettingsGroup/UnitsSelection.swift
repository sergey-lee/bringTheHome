//
//  UnitsSelection.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/04.
//

import SwiftUI

struct UnitsSelection: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var msc: MainScreenController
    @AppStorage("weightUnit") var weightUnit = Defaults.weightUnit
    @AppStorage("heightUnit") var heightUnit = Defaults.heightUnit
    @AppStorage("temperatureUnit") var temperatureUnit = Defaults.temperatureUnit
    @AppStorage("humidityUnit") var humidityUnit = Defaults.humidityUnit
    
    @State var selectedWeightUnit = 0
    @State var selectedHeightUnit = 0
    @State var selectedTemperatureUnit = 0
    @State var selectedHumidityUnit = 0
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ListSectionView(selected: $selectedWeightUnit, title: "WEIGHT", list: weightList)
                ListSectionView(selected: $selectedHeightUnit, title: "HEIGHT", list: heightList)
                ListSectionView(selected: $selectedTemperatureUnit, title: "TEMPERATURE", list: temperatureList)
                ListSectionView(selected: $selectedHumidityUnit, title: "HUMIDITY", list: humidityList)
                
                Text("SETTINGS_HUMIDITY_DESC")
                    .foregroundColor(.gray300)
                    .font(regular14Font)
                    .padding(.horizontal, Size.w(30))
                    .padding(.bottom, Size.h(100))
                
            }
        }
        .navigationView(back: back, title: "UNIT", bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
        .navigationBarItems(trailing: Button(action: save) {
            Text("FINISH")
                .font(light14Font)
        })
        .onAppear() {
            selectedWeightUnit = weightUnit
            selectedHeightUnit = heightUnit
            selectedTemperatureUnit = temperatureUnit
            selectedHumidityUnit = humidityUnit
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func save() {
        weightUnit = selectedWeightUnit
        heightUnit = selectedHeightUnit
        temperatureUnit = selectedTemperatureUnit
        humidityUnit = selectedHumidityUnit
        userManager.getUserData()
        msc.refresh()
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct UnitsSelection_Previews: PreviewProvider {
    static let sessionManager = SessionManager()
    static let deviceManager = DeviceManager(username: "sergey@mellowingfactory.com")
    static let userManager = UserManager(username: "sergey@mellowingfactory.com", userId: "1")
    static let msc = MainScreenController()
    
    static var previews: some View {
        NavigationView {
            UnitsSelection()
                .environmentObject(sessionManager)
                .environmentObject(deviceManager)
                .environmentObject(userManager)
                .environmentObject(msc)
                .onAppear {
                    userManager.apiNodeUser = ApiNodeUser(id: "lisa", email: "lisa@gmail.com", name: "Lisa", familyName: "Wilson", membership: "basic", fakeLocation: "Dallas, TX")
                }
        }
    }
}
