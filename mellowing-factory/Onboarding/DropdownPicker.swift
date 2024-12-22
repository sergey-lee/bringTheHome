//
//  DropDownPicker.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/08/22.
//

import SwiftUI

struct DropdownPicker: View {
    @Binding var isActive: Bool
    @Binding var selectedOption: Int
    
    var state: DropdownState
    var placeholder: LocalizedStringKey
    var unit: LocalizedStringKey?
    
    var body: some View {
        Button(action: {
                withAnimation {
                    isActive.toggle()
                }
        }) {
            HStack(alignment: .center) {
                HStack(alignment: .center, spacing: 0) {
                    if selectedOption != -1 {
                        Group {
                            if state == .gender {
                                let genders = ["MALE", "FEMALE", "OTHER"]
                                Text(LocalizedStringKey(genders[selectedOption]))
                            } else {
                                Text(LocalizedStringKey(String(selectedOption)))
                            }
                            
                            if unit != nil {
                                Text(unit!)
                            } else {
                                Text("")
                            }
                        }
                        .font(regular18Font)
                        .foregroundColor(.gray900)
                    } else {
                        Text(placeholder)
                            .font(regular18Font)
                            .foregroundColor(.gray300)
                    }
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 13, height: 7)
                    .font(light14Font)
                    .foregroundColor(.gray300)
            }
        }
        .modifier(CustomInputViewModifier(color: .gray200, background: isActive ? Color.gray10 : .clear, height: 50))
    }
}

struct CustomDropdownPicker: View {
    @Binding var isActive: Bool
    @Binding var options: [Int]
    @Binding var value: Int

    var state: DropdownState
    
    var body: some View {
        Button(action: {
                withAnimation {
                    isActive.toggle()
                }
        }) {
            HStack(alignment: .center) {
                HStack(alignment: .center, spacing: 0) {
                    if value != -1 {
                        HStack(alignment: .center, spacing: 0) {
                            Text(label)
                            Text(unit)
                        }
                        .font(regular18Font)
                        .foregroundColor(.gray900)
                    } else {
                        Text(LocalizedStringKey(state.description))
                            .font(regular18Font)
                            .foregroundColor(.gray300)
                    }
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 13, height: 7)
                    .font(light14Font)
                    .foregroundColor(.gray300)
            }
        }
        .modifier(CustomInputViewModifier(color: .gray200, background: isActive ? Color.gray10 : .clear, height: 50))
    }
    
    var label: String {
        if options[1] == 1 {
            return value.description
        } else {
            if state == .height {
                return Double(value).feetAndInches
            } else {
                return Double(value).kilogram.converted(to: .pounds).value.clean
            }
        }
    }
    
    var unit: String {
        if state == .height {
            return options[1] == 0 ? UnitLength.feet.symbol : UnitLength.centimeters.symbol
        } else {
            return options[1] == 0 ? UnitMass.pounds.symbol : UnitMass.kilograms.symbol
        }
    }
}
