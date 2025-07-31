//
//  HomeView.swift
//  AuthDemo
//
//  Created by Zakariya Veasy on 7/27/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            NavigationStack {
                CategoryListView(vm: FavoritesSectionViewModel(category: .cities))
            }
            .tabItem { Label("Cities", systemImage: FavoriteCategory.cities.icon) }

            NavigationStack {
                CategoryListView(vm: FavoritesSectionViewModel(category: .hobbies))
            }
            .tabItem { Label("Hobbies", systemImage: FavoriteCategory.hobbies.icon) }

            NavigationStack {
                CategoryListView(vm: FavoritesSectionViewModel(category: .books))
            }
            .tabItem { Label("Books", systemImage: FavoriteCategory.books.icon) }
        }
    }
}

