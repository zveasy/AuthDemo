//
//  FavoritesRepository.swift
//  AuthDemo
//
//  Created by Zakariya Veasy on 7/27/25.
//

import Foundation
import FirebaseFirestore

final class FavoritesRepository {
    private let db = Firestore.firestore()

    private func itemsRef(uid: String, category: FavoriteCategory) -> CollectionReference {
        db.collection("users").document(uid)
          .collection("favorites").document(category.rawValue)
          .collection("items")
    }

    func listen(uid: String,
                category: FavoriteCategory,
                onChange: @escaping (Result<[FavoriteItem], Error>) -> Void) -> ListenerRegistration {
        itemsRef(uid: uid, category: category)
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { snap, err in
                if let err = err { onChange(.failure(err)); return }
                let items: [FavoriteItem] = snap?.documents.map { doc in
                    let data = doc.data()
                    let title = data["title"] as? String ?? ""
                    let ts = data["createdAt"] as? Timestamp
                    return FavoriteItem(id: doc.documentID, title: title, createdAt: ts?.dateValue())
                } ?? []
                onChange(.success(items))
            }
    }

    func add(uid: String, category: FavoriteCategory, title: String) async throws {
        try await itemsRef(uid: uid, category: category).addDocument(data: [
            "title": title,
            "createdAt": FieldValue.serverTimestamp()
        ])
    }

    func delete(uid: String, category: FavoriteCategory, id: String) async throws {
        try await itemsRef(uid: uid, category: category).document(id).delete()
    }

    func update(uid: String, category: FavoriteCategory, item: FavoriteItem) async throws {
        guard let id = item.id else { return }
        try await itemsRef(uid: uid, category: category).document(id)
            .setData(["title": item.title], merge: true)
    }
}
