//
//  DropdownSelector.swift
//  mellowing-factory
//
//  Created by Florian Topf on 03.01.22.
//

import SwiftUI

enum DropdownState {
    case none, birthYear, gender, weight, height
    
    var description: String {
        switch self {
        case .weight: return "WEIGHT"
        case .height: return "HEIGHT"
        case .birthYear: return "BIRTH_YEAR"
        case .gender: return "GENDER"
        case .none: return ""
        }
    }
}

struct DropdownSelector: View {
    @Binding var isDropdownShown: Bool
    
    @Binding var activeDropdownState: DropdownState
    @Binding var isDisabled: Bool
    @Binding var selectedOption: DropdownOption?
    
    var preferredDropdownState: DropdownState
    var placeholder: LocalizedStringKey
    var options: [DropdownOption]
    var unit: LocalizedStringKey?
    
    init(
         isDropdownShown: Binding<Bool> = .constant(false),
         activeDropdownState: Binding<DropdownState> = .constant(.none),
         preferredDropdownState: DropdownState = .none,
         placeholder: LocalizedStringKey,
         options: [DropdownOption],
         selectedOption: Binding<DropdownOption?>,
         isDisabled: Binding<Bool> = .constant(false),
         unit: LocalizedStringKey? = nil
    ) {
        _activeDropdownState = activeDropdownState
        self.preferredDropdownState = preferredDropdownState
        self.placeholder = placeholder
        self.options = options
        _selectedOption = selectedOption
        _isDisabled = isDisabled
        self.unit = unit
        _isDropdownShown = isDropdownShown
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                if !options.isEmpty {
                    withAnimation {
                        isDropdownShown.toggle()
                        activeDropdownState = isDropdownShown ? preferredDropdownState : .none
                    }
                }
                
            }) {
                HStack(alignment: .center) {
                    HStack(alignment: .center, spacing: 0) {
                        if selectedOption == nil {
                            Text(placeholder)
                                .font(regular18Font)
                                .foregroundColor(.blue300.opacity(0.3))
                        } else {
                            Group {
                                Text(LocalizedStringKey(selectedOption!.value))
                                if unit != nil {
                                    Text(unit!)
                                } else {
                                    Text("")
                                }
                            }
                            .font(regular18Font)
                            .foregroundColor(.white)
                        }
                    }
                    Spacer()
                    Image(systemName: isDropdownShown ? "chevron.up" : "chevron.down")
                        .resizable()
                        .frame(width: Size.w(10), height: Size.w(6))
                        .font(regular18Font)
                        .foregroundColor(.blue300.opacity(selectedOption == nil ? 0.3 : 1))
                }
            }
            .modifier(CustomInputViewModifier(color: .blue300.opacity(options.isEmpty ? 0.3 : 1),
                                              background: isDropdownShown ? Color.blue800 : .clear,
                                              corners: !isDropdownShown || selectedOption == nil ? .allCorners : [.topLeft, .topRight], height: 54))
            .disabled(isDisabled)
            .opacity(isDisabled ? 0.2 : 1)
            .overlay(
                VStack {
                    Spacer().frame(height: 54)
                    if isDropdownShown {
                        Dropdown(options: options.filter { $0 != selectedOption }, unit: unit, onSelect: { option in
                            isDropdownShown = false
                            activeDropdownState = .none
                            selectedOption = option
                        })
                    }
                }, alignment: .topLeading
            )
        }
        .onTapGesture {
            isDropdownShown.toggle()
        }
        .onChange(of: activeDropdownState) { state in
            if state != preferredDropdownState {
                isDropdownShown = false
            }
        }
        
        .onAppear {
            // MARK: Setting first item from list instead of placeholder
           if !options.isEmpty {
               self.selectedOption = options.first
           }
       }
        
//        .overlay(
//            VStack {
//                if isDropdownShown {
//                    Spacer().frame(height: 100)
//                    Dropdown(options: options.filter { $0 != selectedOption }, unit: unit, onSelect: { option in
//                        isDropdownShown = false
//                        activeDropdownState = .none
//                        selectedOption = option
//                    })
//                }
//            },
//            alignment: .topLeading
//        )
//        .onTapGesture {
//            isDropdownShown.toggle()
//        }
//        .onChange(of: activeDropdownState) { state in
//            if state != preferredDropdownState {
//                isDropdownShown = false
//            }
//
//        }
//        .onAppear {
//           if !options.isEmpty {
//               self.selectedOption = options.first
//           }
//       }
    }
}

struct Dropdown: View {
    var options: [DropdownOption]
    var unit: LocalizedStringKey?
    var onSelect: ((_ option: DropdownOption) -> Void)?
    
    var body: some View {
        let height = Size.w(CGFloat(options.count * 54))
        ZStack {
            
            //            List(options) { option in
            //                DropdownRow(option: option, unit: unit, onOptionSelected: onSelect)
            //            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        DropdownRow(option: option, unit: unit, onOptionSelected: onSelect)
                    }
                }.frame(height: height > Size.h(320) ? height + height - Size.h(320) : height)
            }
            .font(regular18Font)
            .foregroundColor(.blue300)
        }
        
        .modifier(DropDownModifier(values: options.count))
    }
}

struct DropdownRow: View {
    var option: DropdownOption
    var unit: LocalizedStringKey?
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?
    
    var body: some View {
        Button(action: {
            if let onOptionSelected = onOptionSelected {
                onOptionSelected(option)
            }
        }) {
            VStack(spacing: 0) {
                HStack {
                    Group {
                        Text(LocalizedStringKey(option.value)) +
                        (unit != nil ? Text(" ") + Text(unit!) : Text(""))
                        
                    }
                    .font(regular18Font)
                    .foregroundColor(.blue300)
                    .padding(Size.h(16))
                    Spacer()
                }
                Rectangle()
                    .fill(Color.blue400)
                    .frame(height: 1)
                    .edgesIgnoringSafeArea(.horizontal)
            }
        }.frame(height: Size.w(54))
    }
}

struct DropdownSelector_Previews: PreviewProvider {
    static var previews: some View {
        OtherView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 11 Pro")
    }
    
    struct OtherView: View {
        @State var activeDropdownState: DropdownState = .none
        
        @State var birthYearOption: DropdownOption?
        @State var weightOption: DropdownOption?
        
        var body: some View {
            VStack {
                DropdownSelector(
                    activeDropdownState: $activeDropdownState,
                    preferredDropdownState: .birthYear,
                    placeholder: "BIRTH_YEAR",
                    options: getBirthYearOptions(),
                    selectedOption: $birthYearOption
                ).zIndex(2)
                DropdownSelector(
                    activeDropdownState: $activeDropdownState,
                    preferredDropdownState: .weight,
                    placeholder: "WEIGHT",
                    options: getWeightOptions(),
                    selectedOption: $weightOption,
                    unit: "KG"
                ).zIndex(1)
            }
            .padding(.horizontal)
        }
    }
}
