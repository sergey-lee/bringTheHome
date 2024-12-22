//
//  mellowing_factoryApp.swift
//  mellowing-factory
//
//  Created by Florian Topf on 31.07.21.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin
import RevenueCat

@main
struct mellowing_factoryApp: App {
    @StateObject var sessionManager = SessionManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ApplicationView()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .accentColor(.gray800)
                .preferredColorScheme(.light)
                .environment(\.colorScheme, .light)
                .environmentObject(sessionManager)
                .environment(\.locale, .init(identifier: languageList[sessionManager.appLanguage].loc))
        }
    }
}

struct ApplicationView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
//        NewBleView()
        switch sessionManager.appState {
        case .auth:
            SignInView()
                .onAppear {
                    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.white)]
                }
        case .appOnboarding:
            AppOnboardingView()
        case .session(let user):
            SessionView(deviceManager: DeviceManager(username: user.username),
                        userManager: UserManager(username: user.username, userId: user.username),
                        msc: MainScreenController()
            )
            .onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.gray700)]
            }
        case .unknown:
            LogoLoadingView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupRevenueCat()
        setDefaults()
        setupUI()
        configureAmplify()

        return true
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
        } catch {
            fatalError("An error occurred setting up session.")
        }
    }

    private func setupUI() {
        /// Sets Alert, Picker color scheme to .light
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).overrideUserInterfaceStyle = UIUserInterfaceStyle(.light)
        UITextView.appearance().backgroundColor = .clear
        UIPickerView.appearance().overrideUserInterfaceStyle = .light
        
        /// Navigation Title - colors
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.clear]
//        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.white)]
        
        /// Picker / SegmentedPickerStyle
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.gray700)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.gray300)], for: .normal)
        
        /// Hides native TabBar
        UITabBar.appearance().isHidden = true
    }
    
    /// Setting default values for User Defaults. Works only once, on first start
    private func setDefaults() {
//        Defaults.isAppOnboarded = false
//        RealmDeleteAll()
        /// Logic for initializing the language depending on the system language at first startup
        var localeInt = 0
        if let locale = Locale.current.languageCode {
            if locale == languageList[1].loc {
                localeInt = languageList[1].number
            } else if locale == languageList[2].loc {
                localeInt = languageList[2].number
            }
        }
        
        UserDefaults.standard.register(defaults: [
            "isAppOnboarded": false,
            "weeklyHasData": false,
            "didLaunchBefore": false,
            "autoLoginEnabled": true,
            "saveIDEnabled": true,
            "isTermsCompleted": false,
            "isUserOnboardingCompleted": false,
            "appLanguage": localeInt
        ])
    }
    
    /// Setting Revenue Cat Subscriptions
    
    private func setupRevenueCat() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: Defaults.revenueKey)
    }
}
