//
//  CustomWheelPicker.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/12.
//

import SwiftUI

struct CustomWheelPicker: View {
    @Binding var isWheelOpened: Bool
    @Binding var value: Int
    
    @Binding var selections: [Int]
    @State var list: [Double]
    
    var state: DropdownState

    var body: some View {
        ZStack {
            Color.black.opacity(isWheelOpened ? 0.5 : 0).ignoresSafeArea()
            VStack {
                Spacer()
                Color.black.opacity(isWheelOpened ? 0.001 : 0).ignoresSafeArea()
                    .frame(height: UIScreen.main.bounds.height * 0.6)
                    .onTapGesture() {
                        withAnimation {
                            isWheelOpened.toggle()
                        }
                    }
            }
            VStack {
                Spacer()
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.value = Int(list[selections.first ?? 1])
                            withAnimation {
                                isWheelOpened.toggle()
                            }
                        }) {
                            Text("CONFIRM")
                                .font(semiBold18Font)
                                .foregroundColor(.blue400)
                        }.padding(Size.h(15))
                    }
                    PickerView(selections: $selections, data: list, state: state)
                        .id(selections.last)
                    Spacer()
                }.frame(height: Size.w(250 + 48))
                 .background(Color.gray50)
                 .offset(y: isWheelOpened ? 0 : Size.w(250 + 48))
            }.ignoresSafeArea(.all)
        }
        .onAppear {
            withAnimation {
                if state == .height {
                    self.selections = [60,0]
                } else {
                    self.selections = [30,0]
                }
            }
        }
    }
}

struct PickerView: UIViewRepresentable {
    @Binding var selections: [Int]
    
    @State var data: [Double]
    
    var state: DropdownState
    
    func makeCoordinator() -> PickerView.Coordinator {
        return PickerView.Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<PickerView>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<PickerView>) {
        for i in 0...(self.selections.count - 1) {
            view.selectRow(self.selections[i], inComponent: i, animated: true)
        }
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: PickerView
        
        init(_ pickerView: PickerView) {
            self.parent = pickerView
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let units = parent.state == .height ? [UnitLength.feet, UnitLength.centimeters] : [UnitMass.pounds, UnitMass.kilograms]
            var pickerLabel: UILabel? = (view as? UILabel)
            if pickerLabel == nil {
                pickerLabel = UILabel()
            }
            pickerLabel?.font = UIFont(name: "Pretendard-Regular", size: Size.w(22))
            pickerLabel?.textAlignment = .center
            
            let label: String = {
                if component == 0 {
                    if self.parent.selections.last != 0 {
                        return self.parent.data[row].clean
                    } else {
                        if parent.state == .height {
                            return Double(self.parent.data[row]).feetAndInches
                        } else {
                            return self.parent.data[row].kilogram.converted(to: .pounds).value.clean
                        }
                    }
                } else {
                    return units[row].symbol
                }
            }()
            
            pickerLabel?.text = label
            return pickerLabel ?? UILabel()
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            let units = parent.state == .height ? [UnitLength.feet, UnitLength.centimeters] : [UnitMass.pounds, UnitMass.kilograms]
            return component == 0 ? self.parent.data.count : units.count
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            if component == 0 {
                return 50
            } else {
                return 50
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            let units = parent.state == .height ? [UnitLength.feet, UnitLength.centimeters] : [UnitMass.pounds, UnitMass.kilograms]
                if component == 0 {
                    if self.parent.selections.last != 0 {
                        return self.parent.data[row].clean
                    } else {
                        if parent.state == .height {
                            return Double(self.parent.data[row]).feetAndInches
                        } else {
                            return self.parent.data[row].pounds.value.clean
                        }
                    }
                } else {
                    return units[row].symbol
                }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selections[component] = row
        }
        
        func valueForRow(row: Int) -> Int {
            return self.parent.data.count
        }
    }
}

extension Double {
    var centimeters: Measurement<UnitLength>{
        return Measurement(value: self, unit: UnitLength.centimeters)
    }
    var inches: Measurement<UnitLength>{
        return Measurement(value: self, unit: UnitLength.inches)
    }
    
    var kilogram: Measurement<UnitMass>{
        return Measurement(value: self, unit: UnitMass.kilograms)
    }
    var pounds: Measurement<UnitMass>{
        return Measurement(value: self, unit: UnitMass.pounds)
    }
    
    var feetAndInches: String {
        let feet = Int(self.centimeters.converted(to: .inches).value / 12)
        let inches = Int(self.centimeters.converted(to: .inches).value - Double(feet * 12))
        return "\(feet)'\(inches)"
    }
}
