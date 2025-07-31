//
//  AuthDemoApp.swift
//  AuthDemo
//
//  Created by Zakariya Veasy on 7/27/25.
//

import SwiftUI
import FirebaseCore

@main
struct AuthDemoApp: App {
    @StateObject private var auth = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
        }
    }
}
