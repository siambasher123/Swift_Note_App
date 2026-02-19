import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 25) {
                Text("✏️ NoteApp")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
                    .padding(.bottom, 20)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                    )
                    .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                    )
                    .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)

                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .foregroundColor(.white)
                        .font(.footnote)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(20)
                        .shadow(radius: 2)
                }

                HStack(spacing: 15) {
                    Button("Sign In") {
                        authViewModel.signIn(email: email, password: password)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(30)
                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                    .disabled(email.isEmpty || password.isEmpty)

                    Button("Sign Up") {
                        authViewModel.signUp(email: email, password: password)
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
                    .disabled(email.isEmpty || password.isEmpty)
                }

                // Roll number footer
                Text("Roll: 2107078")
                    .font(.caption)
					.foregroundColor(.primary)
                    .padding(.top, 20)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 40)
            .background(.ultraThinMaterial)
            .cornerRadius(30)
            .shadow(radius: 10)
            .padding()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
