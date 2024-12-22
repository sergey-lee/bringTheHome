import SwiftUI
import RevenueCat

struct SubscriptionsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userManager: UserManager
    
    @Binding var goToDetails: Bool
    @Binding var isOpened: Bool
    
    @State var currentOffering: Offering?
    @State var selectedPackage: Package?
    @State var showAlert = false
    
    @Namespace private var animation
    
    var navigation: String?
    let width: CGFloat = Size.w(86)
    
    var body: some View {
        VStack(spacing: Size.w(20)) {
            if !goToDetails {
                Image("harmony-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: Size.w(30))
                    
                    .overlay(
                        Image("logo-light")
                            .resizable()
                            .scaledToFit()
                            .frame(width: Size.w(254), height: Size.w(200))
                            .opacity(selectedPackage == nil ? 0 : 0.5)
                    )
                Text("SIDE.SUBS.HINT")
                    .font(regular16Font)
                    .foregroundColor(.gray800)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, Size.w(22))
                    .padding(.bottom, Size.h(40))
            }
            
            if let currentOffering {
                let offeringsList = currentOffering.availablePackages
                offeringsView(offeringsList: offeringsList.reversed())
            } else {
                Text("SIDE.SUBS.EMPTY")
                    .font(regular16Font)
                    .foregroundColor(.gray800)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(.top, Size.h(16))
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            Purchases.shared.getOfferings { offerings, error in
                if let offer = offerings?.current, error == nil {
                    currentOffering = offer
                } else {
                    print("Error while getting offerings \(String(describing: error))")
                }
            }
        }
    }
    
    @ViewBuilder
    private func offeringsView(offeringsList: [Package]) -> some View {
        
        VStack(spacing: 0) {
            HStack(spacing: Size.w(16)) {
                ForEach(offeringsList) { pkg in
                    OfferingView(goToDetails: $goToDetails, selectedPackage: $selectedPackage, animation: animation, pkg: pkg)
                        .padding(.top, goToDetails ? Size.h(16) : 0)
                }
            }
            .padding(.horizontal, Size.w(22))
            
            if goToDetails {
                Text("SIDE.SUBS.HINT2 \(selectedPackage?.localizedPriceString ?? "")")
                    .foregroundColor(.gray300)
                    .font(regular14Font)
                    .padding(.horizontal, Size.w(22))
                    .padding(.top, Size.h(42))
                    .matchedGeometryEffect(id: "text", in: animation)
                Spacer()
            } else {
                Spacer()
                featuresView(list: offeringsList)
            }
            
            if goToDetails {
                Button(action: purchase) {
                    Text("SUBSCRIBE")
                        .foregroundColor(.white)
                        .font(semiBold20Font)
                        .padding(.top, Size.h(22))
                        .padding(.bottom, Size.h(34))
                        .frame(maxWidth: .infinity)
                        .background(gradientPrimaryButton)
                }
            } else {
                Button(action: {
                    if selectedPackage != nil {
                        withAnimation {
                            goToDetails = true
                        }
                    }
                }) {
                    Text("NEXT")
                        .foregroundColor(.white)
                        .font(semiBold20Font)
                        .padding(.top, Size.h(22))
                        .padding(.bottom, Size.h(34))
                        .frame(maxWidth: .infinity)
                        .background(Color.green400)
                }
                .disabled(selectedPackage == nil)
                .opacity(selectedPackage == nil ? 0.5 : 1)
            }
        }
    }
    
    @ViewBuilder
    private func featuresView(list: [Package]) -> some View {
        VStack(spacing: 0) {
            
            Color.gray50.frame(width: .infinity, height: 1)
            HStack(spacing: 0) {
                VStack(alignment: .leading) {
                    Text("FEATURES")
                        .font(medium16Font)
                        .foregroundColor(.gray600)
                        .frame(height: 40, alignment: .center)
                    Text("NUMBER_OF_MEMBERS")
                        .font(regular14Font)
                        .foregroundColor(.gray400)
                        .frame(height: 40, alignment: .center)
                    Text("DETAILED_VIEW")
                        .font(regular14Font)
                        .foregroundColor(.gray400)
                        .frame(height: 40, alignment: .center)
                }
                .frame(width: width, alignment: .leading)
                
                ZStack {
                    if selectedPackage == nil {
                        Color.blue10.opacity(0.5)
                            .matchedGeometryEffect(id: "selection", in: animation)
                    }
                    
                    VStack(alignment: .center) {
                        Text("Basic")
                            .font(medium16Font)
                            .foregroundColor(.gray600)
                            .frame(height: 40, alignment: .center)
                        Text("2")
                            .font(semiBold18Font)
                            .foregroundColor(.gray700)
                            .frame(height: 40, alignment: .center)
                        Color.gray200
                            .frame(width: Size.w(12), height: Size.w(2))
                            .cornerRadius(2)
                            .frame(height: 40, alignment: .center)
                    }
                }
                
                //                            .padding(.vertical, Size.h(22))
                .frame(width: width, height: Size.h(162), alignment: .center)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedPackage = nil
                    }
                }
                
                ForEach(list) { pkg in
                    ZStack {
                        if selectedPackage == pkg {
                            Color.blue10.opacity(0.5)
                                .matchedGeometryEffect(id: "selection", in: animation)
                        }
                        //                                    .opacity(selectedPackage == pkg ? 0.5 : 0)
                        VStack(alignment: .center) {
                            Text(pkg.identifier)
                                .font(medium16Font)
                                .foregroundColor(.gray600)
                                .frame(height: 40, alignment: .center)
                            Text(pkg.identifier == "Standard" ? "4" : "10")
                                .font(semiBold18Font)
                                .foregroundColor(.gray700)
                                .frame(height: 40, alignment: .center)
                            Image("ic-checkmark-circle")
                                .foregroundColor(.green400)
                                .frame(height: 40, alignment: .center)
                        }
                    }
                    
                    .frame(width: width, height: Size.h(162), alignment: .center)
                    //                                .padding(.vertical, Size.h(22))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedPackage = pkg
                        }
                    }
                    
                }
            }
            .padding(.horizontal, Size.w(22))
            Color.gray50.frame(width: .infinity, height: 1)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .padding(.bottom, Size.h(44))
        .matchedGeometryEffect(id: "text", in: animation)
    }
    
    private func purchase() {
        if let selectedPackage {
            Purchases.shared.purchase(package: selectedPackage) { transaction, customerInfo, error, userCancelled in
                if let error {
                    print(error)
                } else {
                    DispatchQueue.main.async {
                        withAnimation {
                            userManager.getSubscriptionInfo() {
                                if userManager.group == nil {
                                    userManager.createGroup() { _ in
                                        isOpened = false
                                    }
                                } else {
                                    isOpened = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SubscriptionsView_Previews: PreviewProvider {
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
