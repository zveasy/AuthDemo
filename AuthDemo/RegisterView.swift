//
//  RegisterView.swift
//  AuthDemo
//
//  Created by Zakariya Veasy on 7/27/25.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var confirm = ""

    var match: Bool { !password.isEmpty && password == confirm }

    var body: some View {
        Form {
            Section(header: Text("Create Account")) {
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("Password (min 6)", text: $password)
                SecureField("Confirm Password", text: $confirm)
            }
            Section {
                Button("Sign Up") {
                    guard match else { return }
                    Task { await auth.signUp(email: email, password: password) }
                }
                .disabled(!match)
            }
            if let msg = auth.errorMessage {
                Text(msg).foregroundColor(.red)
            }
        }
        .navigationTitle("Register")
    }
}

