//
//  AuthState.swift
//  mellowing-factory
//
//  Created by Florian Topf on 28.01.22.
//

import Amplify
import SwiftUI

enum SignInError {
    case none,
         emptyEmail,
         emptyPassword,
         wrongCredentials,
         generalError
}

enum SignUpError {
    case none,
         emptyEmail,
         emptyPassword,
         emptyName,
         generalError,
         invalidPassword,
         invalidEmail,
         emailExisting,
         passwordMismatch
}

enum ForgotPasswordError {
    case none,
         emptyEmail,
         emptyPassword,
         emptyCode,
         generalError,
         invalidPassword,
         invalidEmail,
         passwordMismatch,
         wrongCode,
         expiredCode
}

enum ConfirmCodeError {
    case none,
         emptyCode,
         wrongCode,
         expiredCode,
         generalError
}

enum AuthState {
    case unknown
    case appOnboarding
    case signUp(error: SignUpError = .none)
    case signIn(error: SignInError = .none)
    case confirmCode(email: String,
                     password: String,
                     error: ConfirmCodeError = .none)
    case session(user: AuthUser)
    case forgotPassword(error: ForgotPasswordError = .none)
}


enum AppState {
    case unknown
    case appOnboarding
    case auth
    case session(user: AuthUser)
}

enum GlobalError: LocalizedStringKey {
    case none,
         emptyName,
         emptyEmail,
         invalidEmail,
         emailExisting,
         emptyPassword,
         invalidPassword,
         passwordMismatch,
         emptyCode,
         wrongCode,
         expiredCode,
         wrongCredentials,
         generalError
    
    var text: LocalizedStringKey {
        switch self {
        case .emptyName:
            return "EMPTY_NAME"
        case .emptyEmail:
            return "EMPTY_EMAIL"
        case .invalidEmail:
            return "INVALID_EMAIL"
        case .emailExisting:
            return "EMAIL_REGISTERED"
        case .emptyPassword:
            return "EMPTY_PASSWORD"
        case .invalidPassword:
            return "PASSWORD_WARNING"
        case .passwordMismatch:
            return "PASSWORD_MISMATCH"
        case .emptyCode:
            return "EMPTY_CODE"
        case .wrongCode:
            return "WRONG_CODE"
        case .expiredCode:
            return "EXPIRED_CODE"
        case .wrongCredentials:
            return "WRONG_USERNAME_OR_PASSWORD"
        case .generalError:
            return "GENERAL_ERROR"
        default:
            return " "
        }
    }
}
