//
//  EditCardsScreen.swift
//  Flashzilla
//
//  Created by Dylan on 29/12/2024.
//

import SwiftUI

struct EditCardsScreen: View {
    // MARK: - ENVIRONMENT PROPERTIES
    @Environment(\.dismiss) private var dismiss
    // MARK: - STATE PROPERTIES
    @State private var cards: [Card] = []
    @State private var prompt: String = ""
    @State private var answer: String = ""
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $prompt)
                    TextField("Answer", text: $answer)
                    Button("Add") {
                        addCard()
                    }
                }
                Section("Cards") {
                    ForEach(0..<cards.count, id: \.self) { index in
                        let card = cards[index]
                        VStack(alignment: .leading) {
                            Text(card.prompt)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text(card.answer)
                                .foregroundStyle(.secondary)
                        }
                    }.onDelete { indexSet in
                        removeCards(at: indexSet)
                    }
                }
            }.navigationTitle("Edit Cards")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
                .onAppear {
                    loadCardsData()
                }
        }
    }
    // MARK: - FUNCTIONS
    private func loadCardsData() {
        guard let data = UserDefaults.standard.data(forKey: "cards") else {
            return
        }
        let decoder = JSONDecoder()
        guard let cards = try? decoder.decode([Card].self, from: data) else {
            return
        }
        self.cards = cards
    }
    private func saveCardsData() {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(cards) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "cards")
        prompt = ""
        answer = ""
    }
    private func addCard() {
        let trimmedPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAnswer = answer.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedPrompt.isEmpty && !trimmedAnswer.isEmpty else {
            return
        }
        let newCard = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(newCard, at: 0)
        saveCardsData()
    }
    private func removeCards(at indexSet: IndexSet) {
        cards.remove(atOffsets: indexSet)
        saveCardsData()
    }
    
}

// MARK: - PREVIEW
#Preview(traits: .sizeThatFitsLayout) {
    EditCardsScreen()
}
