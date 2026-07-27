import SwiftUI

/// شاشة تسجيل الدخول
struct LoginView: View {
    @StateObject private var authManager = AuthenticationManager()
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showPassword = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.2),
                    Color(red: 0.15, green: 0.15, blue: 0.3)
                ]),
                startPoint: .topLeadingDirection,
                endPoint: .bottomTrailingDirection
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Herfy Client")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("تسجيل الدخول عبر ChatGPT")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Login Form
                VStack(spacing: 16) {
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Label("البريد الإلكتروني", systemImage: "envelope.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        TextField("example@openai.com", text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .padding(12)
                            .background(Color(white: 0.1))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Label("كلمة المرور", systemImage: "lock.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        HStack {
                            if showPassword {
                                TextField("", text: $password)
                                    .textInputAutocapitalization(.never)
                            } else {
                                SecureField("", text: $password)
                                    .textInputAutocapitalization(.never)
                            }
                            
                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(12)
                        .background(Color(white: 0.1))
                        .cornerRadius(8)
                    }
                    
                    // Error Message
                    if let error = authManager.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(8)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    // Login Button
                    Button(action: login) {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("دخول")
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.2, green: 0.8, blue: 0.8),
                                Color(red: 0.1, green: 0.6, blue: 0.9)
                            ]),
                            startPoint: .leadingDirection,
                            endPoint: .trailingDirection
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(isLoading || email.isEmpty || password.isEmpty)
                }
                .padding(24)
                .background(Color(white: 0.05))
                .cornerRadius(12)
                
                // Social Login
                VStack(spacing: 12) {
                    Text("أو تسجيل الدخول عبر")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 12) {
                        SocialLoginButton(
                            icon: "apple.logo",
                            label: "Apple",
                            action: { /* Apple Login */ }
                        )
                        
                        SocialLoginButton(
                            icon: "g.circle.fill",
                            label: "Google",
                            action: { /* Google Login */ }
                        )
                    }
                }
                
                Spacer()
                
                // Footer
                HStack(spacing: 4) {
                    Text("ليس لديك حساب؟")
                        .foregroundColor(.gray)
                    
                    Button(action: { }) {
                        Text("إنشاء حساب")
                            .foregroundColor(.cyan)
                    }
                }
                .font(.caption)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
    }
    
    private func login() {
        isLoading = true
        
        Task {
            await authManager.loginWithChatGPT(email: email, password: password)
            isLoading = false
        }
    }
}

// Social Login Button Component
struct SocialLoginButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                
                Text(label)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color(white: 0.1))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

#Preview {
    LoginView()
}
