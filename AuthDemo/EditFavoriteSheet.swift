//
//  EditFavoriteSheet.swift
//  AuthDemo
//
//  Created by Zakariya Veasy on 7/27/25.
//

import SwiftUI

struct EditFavoriteSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State var title: String
    let onSave: (String) -> Void

    var body: some View {
        NavigationStack {
            Form { TextField("Title", text: $title) }
                .navigationTitle("Edit Favorite")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") { onSave(title); dismiss() }
                            .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
        }
    }
}
