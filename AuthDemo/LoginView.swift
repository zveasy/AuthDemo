//
//  LoginView.swift
//  AuthDemo
//
//  Created by Zakariya Veasy on 7/27/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Sign In").font(.title.bold())

            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding().background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            SecureField("Password", text: $password)
                .padding().background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Button {
                Task {
                    await auth.signIn(email: email, password: password)
                }
            } label: {
                Text(auth.isLoading ? "Signing in..." : "Sign In")
                    .frame(maxWidth: .infinity).padding().bold()
            }
            .buttonStyle(.borderedProminent)
            .disabled(auth.isLoading)

            NavigationLink("Create an account") { RegisterView() }

            if let msg = auth.errorMessage {
                Text(msg).foregroundColor(.red).font(.footnote).multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}
