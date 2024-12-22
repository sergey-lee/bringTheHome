//
//  SessionManager.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/01/13.
//

import Amplify
import AWSPluginsCore
import AWSCognitoAuthPlugin
import AuthenticationServices
import SwiftUI

class SessionManager: ObservableObject {
    @Published private(set) var appState: AppState = .unknown
    @Published var error: GlobalError = .none
    @Published var isLoading: Bool = false
    @Published private(set) var tokens: AuthCognitoTokens? = nil
    @Published var navigation: String? = nil
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @AppStorage("isTermsCompleted") var isTermsCompleted = Defaults.isTermsCompleted
    @AppStorage("isUserOnboardingCompleted") var isUserOnboardingCompleted = Defaults.isUserOnboardingCompleted
    @AppStorage("appLanguage") var appLanguage = Defaults.appLanguage
    
    private let userService = UserService()
    
    init() {
        if !Defaults.autoLoginEnabled && Defaults.isAppOnboarded {
            self.signOut()
        }
        self.getCurrentAuthSession()
    }
    
    
    func resetError() {
        self.error = .none
    }
    
    func getCurrentAuthSession() {
        isLoading = true
        if Defaults.isAppOnboarded {
            Task {
                do {
                    let session = try await Amplify.Auth.fetchAuthSession()
                    if session.isSignedIn {
                        self.showCurrentAuthState()
                    } else {
                        print("User not logged in")
                        self.showSignIn()
                    }
                } catch let error as AuthError {
                    print("Sign in failed \(error)")
                } catch {
                    print("Unexpected error: \(error)")
                }
            }
        } else {
            self.showAppOnboarding()
        }
    }
    
    func signOut() {
        Task {
            self.isLoading = true
            _ = await Amplify.Auth.signOut()
            //                    self?.appState = .unknown
            print("Sign out succeeded")
            // MARK: removing all notifications if user signed out
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            // MARK: removing all realm files if user signed out
            RealmDeleteAll()
            //                    self?.clearUserDefaults()
            print(deleteFiles(urlsToDelete: getRealmDocs()))
            Defaults.adminName = nil
            Defaults.presentationMode = false
            self.showCurrentAuthState()
        }
    }
    
    private func clearUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
    
    func signIn() {
        if email.isEmpty {
            setError(error: .emptyEmail)
        }
        
        if password.isEmpty {
            setError(error: .emptyPassword)
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        Task {
            do {
                let signInResult = try await Amplify.Auth.signIn(username: email, password: password)
                print("Sign in succeeded \(signInResult)")
                print("Next step \(signInResult.nextStep)")
                Defaults.signInProvider = "email"
                Defaults.userEmailPlaceholder = Defaults.saveIDEnabled ? self.email : ""
                switch signInResult.nextStep {
                case .done:
                    do {
                        let cognitoUser = try await Amplify.Auth.getCurrentUser()
                        // MARK: Cognito For Korean Server
                        //                    let userId = cognitoUser.username
                        let userId = cognitoUser.userId
                        
                        self.userService.syncAuthAndApiUser(username: userId) { success in
                            self.navigation = nil
                            print("User sync success \(success)")
                            if self.email == presentationAccount || self.email == kickStarterDemoAccount {
                                Defaults.skipOnboarding = true
                                Defaults.presentationMode = true
                                Defaults.weeklyHasData = true
                                print("user: \(String(describing: self.email)). Presentation mode turned on")
                            } else {
                                Defaults.presentationMode = false
                            }
                            self.isLoading = false
                            self.getCurrentAuthSession()
                        }
                    } catch {
                        print("no user")
                        self.isLoading = false
                        self.getCurrentAuthSession()
                    }
                case .confirmSignUp(_):
                    self.resendSignUpCode()
                    self.navigation = "confirmationFromSignIn"
                default:
                    self.setError(error: .generalError)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.resetError()
                    }
                }
            } catch let error as AuthError {
                switch error {
                case .validation(_, let errorDescription, let recoverySuggestion, let error):
                    print("\(String(describing: error?.localizedDescription))\n\(errorDescription)\n\(recoverySuggestion)")
                    self.setError(error: .emptyEmail)
                case .notAuthorized(let errorDescription, let recoverySuggestion, let error):
                    print("\(String(describing: error?.localizedDescription))\n\(errorDescription)\n\(recoverySuggestion)")
                    self.setError(error: .wrongCredentials)
                case .invalidState(let errorDescription, let recoverySuggestion, let error):
                    print("\(String(describing: error?.localizedDescription))\n\(errorDescription)\n\(recoverySuggestion)")
                case .sessionExpired(let errorDescription, let recoverySuggestion, let error):
                    print("\(String(describing: error?.localizedDescription))\n\(errorDescription)\n\(recoverySuggestion)")
                    self.setError(error: .expiredCode)
                default:
                    print("General error")
                    self.setError(error: .generalError)
                }
            } catch {
                print("Unexpected error: \(error)")
            }
            self.isLoading = false
            self.getCurrentAuthSession()
        }
    }

    
    func signInWithWebUI(provider: AuthProvider) {
        var window: UIWindow {
            guard
                let scene = UIApplication.shared.connectedScenes.first,
                let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
                let window = windowSceneDelegate.window as? UIWindow
            else {
                return UIWindow()
            }
            return window
        }
        
        let options = AuthWebUISignInRequest.Options(
            scopes: ["email", "openid", "aws.cognito.signin.user.admin"],
            pluginOptions: AWSAuthWebUISignInOptions(preferPrivateSession: true)
        )
        self.isLoading = true
        // MARK: @MainActor needs to use computing variable window
        Task.detached { @MainActor in
            do {
                let signInWithWebUIResult = try await Amplify.Auth.signInWithWebUI(for: provider, presentationAnchor: window, options: options)
                
                switch signInWithWebUIResult.nextStep {
                case .done:
                    let username = try await Amplify.Auth.getCurrentUser().username
                    
                    switch provider {
                    case .apple:
                        Defaults.signInProvider = "apple"
                    case .facebook:
                        Defaults.signInProvider = "facebook"
                    case .google:
                        Defaults.signInProvider = "google"
                    default:
                        Defaults.signInProvider = "other"
                    }
                    
                    self.userService.syncAuthAndApiUser(username: username) { success in
                        print("User sync success \(success)")
                        Defaults.autoLoginEnabled = true
                        self.isUserOnboardingCompleted = false
                    }
                    self.getCurrentAuthSession()
                default: print("undone")
                }
            } catch {
                self.getCurrentAuthSession()
                print("Sign in failed: \(error)")
            }
            self.isLoading = false
        }
    }
    
    func setError(error: GlobalError) {
        DispatchQueue.main.async {
            withAnimation {
                self.error = error
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation {
                self.resetError()
            }
        }
    }
    
    func signUp(name: String,
                familyName: String,
                marketing: Bool, completion: @escaping (Bool) -> Void) {
        if name.isEmpty {
            self.setError(error: .emptyName)
        }
        
        if email.isEmpty {
            self.setError(error: .emptyEmail)
        }
        
        if password.isEmpty {
            self.setError(error: .emptyPassword)
        }
        
        if !isPasswordValid(password: password) {
            self.setError(error: .invalidPassword)
        }
        
        let marketingString = marketing ? "1" : "0"
        
        let attributes = [
            AuthUserAttribute(.email, value: email),
            AuthUserAttribute(.name, value: name),
            AuthUserAttribute(.familyName, value: familyName),
//            AuthUserAttribute(.unknown("custom:marketing"), value: marketingString)
        ]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        print("trying to sign up")
        print("options: \(options)")
        print("email: \(email)")
        print("password: \(password)")
        
        Task {
            do {
                let signUpResult = try await Amplify.Auth.signUp(username: email, password: password, options: options)
                print("Sign up succeeded \(signUpResult)")
                print("Next step \(signUpResult.nextStep)")
                switch signUpResult.nextStep {
                case .done:
                    print("done")
                    self.signIn()
                case .confirmUser(_, _, _):
                    self.navigation = "confirmationFromSignUp"
                }
                self.isLoading = false
                completion(true)
            } catch let error as AuthError {
                let cognitoError = error.underlyingError as? AWSCognitoAuthError
                switch cognitoError {
                case .usernameExists:
                    self.setError(error: .emailExisting)
                case .codeMismatch:
                    self.setError(error: .wrongCode)
                case .codeExpired:
                    self.setError(error: .expiredCode)
                case .invalidParameter:
                    self.setError(error: .invalidEmail)
                case .invalidPassword:
                    self.setError(error: .invalidPassword)
                default:
                    self.setError(error: .generalError)
                }
            } catch {
                print(error)
                self.setError(error: .generalError)
            }
            self.isLoading = false
            completion(false)
        }
    }
    
    func resendSignUpCode () {
        self.isLoading = true
        Task {
            do {
                let result = try await Amplify.Auth.resendSignUpCode(for: email)
                print(result.destination)
                print(String(describing: result.attributeKey))
            } catch {
                print(error)
            }
            self.isLoading = false
        }
    }
    
    func confirmSignUp(code: String, completion: @escaping (Bool) -> Void) {
        if code.isEmpty {
            self.setError(error: .emptyCode)
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        Task {
            do {
                let result = try await Amplify.Auth.confirmSignUp(for: email, confirmationCode: code)
                print("Confirm succeeded \(result)")
                if result.isSignUpComplete {
                    self.isLoading = false
                    completion(true)
//                    self.signIn()
                } else {
                    self.isLoading = false
                    completion(false)
                }
            } catch let error as AuthError {
                let cognitoError = error.underlyingError as? AWSCognitoAuthError
                switch cognitoError {
                case .codeMismatch: self.setError(error: .wrongCode)
                case .codeExpired: self.setError(error: .expiredCode)
                default: self.setError(error: .generalError)
                }
                self.isLoading = false
                completion(false)
            } catch {
                print(error)
                self.setError(error: .expiredCode)
                self.isLoading = false
                completion(false)
            }
        }
    }
    
    func updateAttributes(marketingString: String? = nil, name: String? = nil, familyName: String? = nil) {
        //        DispatchQueue.main.async {
        //            self.isLoading = true
        //        }
        Task {
            do {
                var listOFAttributesToUpdate: [AuthUserAttribute] = []
                if let marketingString {
                    listOFAttributesToUpdate.append(AuthUserAttribute(.unknown("custom:marketing"), value: marketingString))
                }
                if let name {
                    listOFAttributesToUpdate.append(AuthUserAttribute(.name, value: name))
                }
                if let familyName {
                    listOFAttributesToUpdate.append(AuthUserAttribute(.familyName, value: familyName))
                }
                let result = try await Amplify.Auth.update(userAttributes: listOFAttributesToUpdate)
                switch result.first?.value.nextStep {
                case .confirmAttributeWithCode(let deliveryDetails, let info):
                    print("Confirm the attribute with details send to - \(deliveryDetails) \(String(describing: info))")
                case .done:
                    print("Update completed")
                case .none:
                    print("Update attribute failed")
                }
            } catch {
                print("Update attribute failed with error \(error)")
            }
        }
    }
    
    func updatePassword(confirmCode: String,
                        completion: @escaping (Bool) -> Void
    ) {
        if password.isEmpty {
            self.setError(error: .emptyPassword)
        }
        
        if !isPasswordValid(password: password) {
            self.setError(error: .invalidPassword)
        }
        
        //        if password != confirmPassword {
        //            self.setError(error: .passwordMismatch)
        //        }
        
        if confirmCode.isEmpty {
            self.setError(error: .emptyCode)
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        Task {
            do {
                try await Amplify.Auth.confirmResetPassword(for: email, with: password, confirmationCode: confirmCode)
                self.isLoading = false
                completion(true)
            } catch let error as AuthError {
                let cognitoError = error.underlyingError as? AWSCognitoAuthError
                switch cognitoError {
                case .codeMismatch:
                    self.setError(error: .wrongCode)
                case .codeExpired:
                    self.setError(error: .expiredCode)
                default:
                    self.setError(error: .generalError)
                }
                self.isLoading = false
                completion(false)
            } catch {
                print(error)
                self.isLoading = false
                completion(false)
            }
        }
    }
    
    func requestResetCode(completion: @escaping (Bool) -> Void) {
        if email.isEmpty {
            self.setError(error: .emptyEmail)
        }
        
        if !isEmailValid(email: email) {
            self.setError(error: .invalidEmail)
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        Task {
            do {
                let result = try await Amplify.Auth.resetPassword(for: email)
                switch result.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, _):
                    print("Confirm reset password with code send to \(deliveryDetails)")
                case .done:
                    print("Reset completed")
                }
                self.isLoading = false
                completion(true)
            } catch {
                print(error)
                self.setError(error: .generalError)
                self.isLoading = false
                completion(false)
                
            }
        }
    }
    
    func showAppOnboarding() {
        DispatchQueue.main.async {
            self.isLoading = false
            self.appState = .appOnboarding
        }
    }
    
    func showSignIn() {
        DispatchQueue.main.async {
            self.appState = .auth
            self.isLoading = false
            self.tokens = nil
        }
    }
    
    private func showSession(user: AuthUser) {
        DispatchQueue.main.async {
            self.appState = .session(user: user)
            self.isLoading = false
        }
    }
    
    private func showCurrentAuthState() {
        Task {
            do {
                let user = try await Amplify.Auth.getCurrentUser()
                showSession(user: user)
            } catch {
                showSignIn()
            }
        }
    }
}
