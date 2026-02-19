import Firebase
import SwiftUI

@main
struct assignment1App: App {
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
        print("Configured Firebase!!!")
    }

    var body: some Scene {
        WindowGroup {
            if authViewModel.isSignedIn {
                ContentView()
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
