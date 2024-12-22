//
//  OfferingView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/05.
//

import SwiftUI
import RevenueCat

struct OfferingView: View {
    @Binding var goToDetails: Bool
    @Binding var selectedPackage: Package?
    let animation: Namespace.ID
    
    let pkg: Package
    
    var body: some View {
        let isStandard = pkg.identifier == "Standard"
        let selected = selectedPackage == pkg
        
        if selected || !goToDetails {
            VStack {
                HStack {
                    if !goToDetails {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(isStandard ? Color.green500 : Color.blue500)
                                .frame(width: Size.w(22), height: Size.w(22))
                            
                            Image("ic-checkmark")
                                .foregroundColor(.white)
                                .opacity(selected ? 1 : 0)
                        }
                    }

                    let text = goToDetails ? pkg.identifier + " Plan" : pkg.identifier
                    Text(text)
                        .foregroundColor(.white)
                        .font(medium20Font)
                        .shadow(radius: 1)
                }
                .padding(.vertical, Size.h(16))
                .frame(maxWidth: .infinity)
                .background(isStandard ? Color.green300 : Color.blue400)
                
                priceView()
                
                if goToDetails {
                    HStack {
                        HStack {
                            Image("ic-person")
                                .resizable()
                                .scaledToFit()
                                .frame(width: Size.w(10), height: Size.w(12))
                            Text("MAX") + Text(isStandard ? "4" : "10")
                        }
                            .foregroundColor(isStandard ? .green300 : .blue300)
                            .font(medium14Font)
                            .padding(.vertical, Size.h(6))
                            .padding(.horizontal, Size.w(16))
                            .background(isStandard ? Color.green10 : Color.blue10)
                            .cornerRadius(16)
                        
                        Text("DETAILED_VIEW")
                            .foregroundColor(isStandard ? .green300 : .blue300)
                            .font(medium14Font)
                            .padding(.vertical, Size.h(6))
                            .padding(.horizontal, Size.w(16))
                            .background(isStandard ? Color.green10 : Color.blue10)
                            .cornerRadius(16)
                    }
                    .padding(.bottom, Size.h(16))
                    
                    Divider()
                    
                    VStack(spacing: Size.h(15)) {
                        HStack {
                            Text("PERIOD")
                                .foregroundColor(.gray300)
                            Spacer()
                            HStack(spacing: 0) {
                                Text(Date().toString(dateFormat: "YYYY.MM.dd"))
                                Text(" ~ ")
                                Text(endPeriod.toString(dateFormat: "YYYY.MM.dd"))
                            }.foregroundColor(.gray500)
                        }
                        .font(regular14Font)
                        .padding(.top, Size.h(10))
                        
                        HStack {
                            Text("NEXT_PAYMENT_DATE")
                                .foregroundColor(.gray300)
                            Spacer()
                            Text(endPeriod.toString(dateFormat: "YYYY.MM.dd"))
                                .foregroundColor(.gray500)
                        }
                        .font(regular14Font)
                    }
                    .padding(.horizontal, Size.w(22))
                    .padding(.bottom, Size.h(16))
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(selected && !goToDetails ? (isStandard ? Color.green400 : Color.blue400) : Color.gray50)
            )
            .shadow(color: isStandard ? Color.green200.opacity(selected ? 0.1 : 0) : Color.blue200.opacity(selected ? 0.1 : 0), radius: 10, y: 20)
            .shadow(color: isStandard ? Color.green900.opacity(selected ? 0.1 : 0) : Color.blue900.opacity(selected ? 0.1 : 0), radius: 10, y: 40)
            .offset(y: selected ? -15 : 0)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if goToDetails {
                        goToDetails.toggle()
                    } else {
                        selectedPackage = selectedPackage == pkg ? nil : pkg
                    }
                }
                
            }
        }
    }
    
    var endPeriod: Date {
        var dateComponent = DateComponents()
        dateComponent.month = 1
        return Calendar.current.date(byAdding: dateComponent, to: Date())!
    }
    
    @ViewBuilder
    private func priceView() -> some View {
        let isStandard = pkg.identifier == "Standard"
        if goToDetails {
            HStack(alignment: .lastTextBaseline, spacing: 5) {
                Text(pkg.localizedPriceString)
                    .foregroundColor(isStandard ? .green900 : .blue900)
                    .font(bold38Font)
                
                Text("PAYMENT.MONTH")
                    .foregroundColor(isStandard ? .green300 : .blue300)
                    .font(medium16Font)
                    .matchedGeometryEffect(id: pkg.id + "price", in: animation)
            }
                .padding(.top, Size.h(16))

        } else {
            Text(pkg.localizedPriceString)
                .foregroundColor(isStandard ? .green400 : .blue400)
                .font(semiBold36Font)
            Text("PAYMENT.MONTH")
                .foregroundColor(isStandard ? .green300 : .blue300)
                .font(medium16Font)
                .padding(.bottom, Size.h(28))
                .matchedGeometryEffect(id: pkg.id + "price", in: animation)
        }
    }
    
}

struct OfferingView_Previews: PreviewProvider {
    struct Preview: View {
        @State var goToDetails = false
        
        var body: some View {
            NavigationView {
                VStack {
                    SubscriptionsView(goToDetails: $goToDetails, isOpened: .constant(false))
                        .navigationView(back: {})
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray10).ignoresSafeArea()
            }
        }
    }
    
    static var previews: some View {
        Preview()
            .previewDevice("iPhone 14 Pro")
    }
}
