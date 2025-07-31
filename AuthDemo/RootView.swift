//
//  RootView.swift
//  AuthDemo
//
//  Created by Zakariya Veasy on 7/27/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        Group {
            if auth.isAuthenticated {
                HomeView()
            } else {
                NavigationStack { LoginView() }
            }
        }
    }
}

