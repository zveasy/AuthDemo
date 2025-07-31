//
//  FavoriteModels.swift
//  AuthDemo
//
//  Created by Zakariya Veasy on 7/27/25.
//

import Foundation

enum FavoriteCategory: String, CaseIterable, Identifiable, Codable {
    case cities, hobbies, books
    var id: String { rawValue }
    var title: String { rawValue.capitalized }
    var icon: String {
        switch self {
        case .cities: return "building.2"
        case .hobbies: return "paintbrush"
        case .books: return "book"
        }
    }
}

struct FavoriteItem: Identifiable, Codable {
    var id: String?      // Firestore doc ID
    var title: String
    var createdAt: Date?
}
