//
//  OnboardingView.swift
//  mellowing-factory
//
//  Created by Florian Topf on 11.01.22.
//

import SwiftUI
import Amplify

struct OnboardingView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        ZStack {
            if dataExists {
                if !sessionManager.isTermsCompleted {
                    NavigationView {
                        TermsView()
                    }
                } else if !sessionManager.isUserOnboardingCompleted {
                    NavigationView {
                        UserOnboarding()
                    }
                } else {
                    DeviceOnboardingView()
                }
            } else {
                DeviceOnboardingView()
            }  
        }
//        .frame(maxWidth: .infinity)
    }
    
    private var dataExists: Bool {
        return userManager.apiNodeUser.age == nil &&
        userManager.apiNodeUser.gender == nil &&
        userManager.apiNodeUser.weight == nil &&
        userManager.apiNodeUser.height == nil
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .previewDevice("iPhone 11 Pro")
    }
}
