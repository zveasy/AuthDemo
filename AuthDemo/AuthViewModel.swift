//
//  AuthViewModel.swift
//  AuthDemo
//
//  Created by Zakariya Veasy on 7/27/25.
//

import Foundation
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isLoading = false

    private var listener: AuthStateDidChangeListenerHandle?

    init() {
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in self?.user = user }
        }
    }

    deinit {
        if let listener { Auth.auth().removeStateDidChangeListener(listener) }
    }

    var isAuthenticated: Bool { user != nil }

    func signUp(email: String, password: String) async {
        await withLoading {
            do {
                _ = try await Auth.auth().createUser(withEmail: email, password: password)
                self.errorMessage = nil
            } catch {
                self.errorMessage = Self.mapError(error)
            }
        }
    }

    func signIn(email: String, password: String) async {
        await withLoading {
            do {
                _ = try await Auth.auth().signIn(withEmail: email, password: password)
                self.errorMessage = nil
            } catch {
                self.errorMessage = Self.mapError(error)
            }
        }
    }

    func signOut() {
        do { try Auth.auth().signOut(); self.errorMessage = nil }
        catch { self.errorMessage = "Failed to sign out. Try again." }
    }

    private func withLoading(_ work: @escaping () async -> Void) async {
        await MainActor.run { self.isLoading = true }
        await work()
        await MainActor.run { self.isLoading = false }
    }

    static func mapError(_ error: Error) -> String {
        let ns = error as NSError
        if let code = AuthErrorCode(rawValue: ns.code) {
            switch code {
            case .invalidEmail: return "Invalid email address."
            case .emailAlreadyInUse: return "Email already in use."
            case .weakPassword: return "Password must be at least 6 characters."
            case .wrongPassword: return "Wrong password."
            case .userNotFound: return "No account found for that email."
            default: return ns.localizedDescription
            }
        }
        return ns.localizedDescription
    }
}
