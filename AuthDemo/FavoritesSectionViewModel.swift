//
//  FavoritesSectionViewModel.swift
//  AuthDemo
//
//  Created by Zakariya Veasy on 7/27/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FavoritesSectionViewModel: ObservableObject {
    // MARK: - Published state
    @Published var items: [FavoriteItem] = []
    @Published var errorMessage: String?

    // MARK: - Dependencies
    let category: FavoriteCategory
    private let repo = FavoritesRepository()
    private var listener: ListenerRegistration?

    // MARK: - Init
    init(category: FavoriteCategory) {
        self.category = category
        attach()
    }

    // MARK: - Live updates
    func attach() {
        // Remove any existing listener
        listener?.remove()
        listener = nil

        guard let uid = Auth.auth().currentUser?.uid else {
            Task { @MainActor in self.items = [] }
            return
        }

        listener = repo.listen(uid: uid, category: category) { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success(let list): self?.items = list
                case .failure(let error): self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // MARK: - CRUD
    func add(title: String) async {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty, let uid = Auth.auth().currentUser?.uid else { return }
        do {
            try await repo.add(uid: uid, category: category, title: t)
        } catch {
            await MainActor.run { self.errorMessage = error.localizedDescription }
        }
    }

    func delete(at offsets: IndexSet) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        for index in offsets {
            if let id = items[index].id {
                do { try await repo.delete(uid: uid, category: category, id: id) }
                catch { await MainActor.run { self.errorMessage = error.localizedDescription } }
            }
        }
    }

    func rename(item: FavoriteItem, to newTitle: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let t = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        var updated = item
        updated.title = t
        do {
            try await repo.update(uid: uid, category: category, item: updated)
        } catch {
            await MainActor.run { self.errorMessage = error.localizedDescription }
        }
    }

    // MARK: - Listener lifecycle
    func detach() {
        listener?.remove()
        listener = nil
    }

    deinit { detach() }
}
