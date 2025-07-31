//
//  AddFavoriteSheet.swift
//  AuthDemo
//
//  Created by Zakariya Veasy on 7/27/25.
//

import SwiftUI

struct AddFavoriteSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    let onAdd: (String) -> Void

    var body: some View {
        NavigationStack {
            Form { TextField("Title", text: $title) }
                .navigationTitle("Add Favorite")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            onAdd(title)
                            dismiss()
                        }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
        }
    }
}
