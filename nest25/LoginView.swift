import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @AppStorage("userEmail") private var userEmail: String = ""
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer()
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color("PrimaryBlue"))
                
                Text("ElectConnect")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryBlue"))
                
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 30)
                
                Button(action: login) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("PrimaryBlue"))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 30)
                
                Button(action: {
                    showingAlert = true
                    alertMessage = "Password reset functionality would be implemented here."
                }) {
                    Text("Forgot Password?")
                        .font(.subheadline)
                        .foregroundColor(Color("PrimaryBlue"))
                }
                
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        showingAlert = true
                        alertMessage = "Sign up functionality would be implemented here."
                    }) {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryBlue"))
                    }
                }
                .padding(.bottom, 30)
            }
            .padding()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func login() {
        if !email.isEmpty && !password.isEmpty {
            userEmail = email
            withAnimation {
                isLoggedIn = true
            }
        } else {
            showingAlert = true
            alertMessage = "Please enter both email and password."
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}

