import Combine
import FirebaseAuth
import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isSignedIn: Bool = false
    @Published var errorMessage: String = ""

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    init() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.user = user
                self?.isSignedIn = user != nil
            }
        }
    }

    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func signUp(email: String, password: String) {
        errorMessage = ""
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    let code = (error as NSError).code
                    switch code {
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        self.errorMessage = "An account with this email already exists. Try signing in."
                    case AuthErrorCode.invalidEmail.rawValue:
                        self.errorMessage = "That doesn't look like a valid email address."
                    case AuthErrorCode.weakPassword.rawValue:
                        self.errorMessage = "Password is too weak. Use at least 6 characters."
                    default:
                        self.errorMessage = "Sign up failed. Please try again."
                    }
                    return
                }
                self.user = result?.user
                self.isSignedIn = true
            }
        }
    }

    func signIn(email: String, password: String) {
        errorMessage = ""
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    let code = (error as NSError).code
                    switch code {
                    case AuthErrorCode.wrongPassword.rawValue,
                         AuthErrorCode.invalidCredential.rawValue:
                        self.errorMessage = "Incorrect email or password. Please try again."
                    case AuthErrorCode.userNotFound.rawValue:
                        self.errorMessage = "No account found with that email. Try signing up."
                    case AuthErrorCode.invalidEmail.rawValue:
                        self.errorMessage = "That doesn't look like a valid email address."
                    case AuthErrorCode.tooManyRequests.rawValue:
                        self.errorMessage = "Too many attempts. Please wait a moment and try again."
                    default:
                        self.errorMessage = "Sign in failed. Please try again."
                    }
                    return
                }
                self.user = result?.user
                self.isSignedIn = true
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.user = nil
                self.isSignedIn = false
                self.errorMessage = ""
            }
        } catch {
            print("Sign Out Error: \(error.localizedDescription)")
        }
    }
}
