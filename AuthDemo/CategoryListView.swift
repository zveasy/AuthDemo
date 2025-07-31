//
//  CategoryListView.swift
//  AuthDemo
//
//  Created by Zakariya Veasy on 7/27/25.
//

import SwiftUI

struct CategoryListView: View {
    @EnvironmentObject var auth: AuthViewModel
    @StateObject var vm: FavoritesSectionViewModel

    @State private var showAdd = false
    @State private var editingItem: FavoriteItem?
    @State private var editTitle: String = ""

    var body: some View {
        List {
            // Error banner (visible)
            if let msg = vm.errorMessage, !msg.isEmpty {
                Section {
                    Text(msg)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                }
            }

            // Items
            Section {
                ForEach(vm.items) { item in
                    HStack(spacing: 12) {
                        Text(item.title)
                            .lineLimit(2)
                        Spacer()

                        // Visible Edit button
                        Button {
                            editingItem = item
                            editTitle = item.title
                        } label: {
                            Label("Edit", systemImage: "pencil")
                                .labelStyle(.iconOnly)
                                .accessibilityLabel("Edit \(item.title)")
                        }
                        .buttonStyle(.borderless)

                        // Visible Delete button
                        Button(role: .destructive) {
                            if let idx = vm.items.firstIndex(where: { $0.id == item.id }) {
                                Task { await vm.delete(at: IndexSet(integer: idx)) }
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .labelStyle(.iconOnly)
                                .accessibilityLabel("Delete \(item.title)")
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(.vertical, 4)
                    // Swipe actions (Edit + Delete)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            if let idx = vm.items.firstIndex(where: { $0.id == item.id }) {
                                Task { await vm.delete(at: IndexSet(integer: idx)) }
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            editingItem = item
                            editTitle = item.title
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                }
                // System delete (works with EditButton)
                .onDelete { idx in Task { await vm.delete(at: idx) } }
            }
        }
        .navigationTitle(vm.category.title)
        .toolbar {
            // Visible Log Out
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Log Out") { auth.signOut() }
            }
            // Visible Refresh + Edit mode + Add
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button { vm.attach() } label: { Image(systemName: "arrow.clockwise") }
                EditButton()
                Button { showAdd = true } label: { Image(systemName: "plus") }
            }
        }
        // Pull to refresh
        .refreshable { vm.attach() }
        // Add flow
        .sheet(isPresented: $showAdd) {
            AddFavoriteSheet { title in
                Task { await vm.add(title: title) }
            }
        }
        // Edit flow
        .sheet(item: $editingItem) { item in
            EditFavoriteSheet(title: editTitle) { newTitle in
                Task { await vm.rename(item: item, to: newTitle) }
            }
        }
        .onAppear { vm.attach() } // fetch on load
    }
}
