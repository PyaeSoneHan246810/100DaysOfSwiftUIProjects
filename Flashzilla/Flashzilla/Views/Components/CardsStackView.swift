//
//  CardsStackView.swift
//  Flashzilla
//
//  Created by Dylan on 27/12/2024.
//

import SwiftUI

struct CardsStackView: View {
    // MARK: - PROPERTIES
    @Binding var cards: [Card]
    let onRemove: (Int) -> Void
    // MARK: - BODY
    var body: some View {
        ZStack {
            ForEach(0..<cards.count, id: \.self) { index in
                CardView(
                    card: cards[index],
                    onRemove: {
                        withAnimation {
                            onRemove(index)
                        }
                    }
                ).stacked(for: cards.count, at: index)
                    .allowsHitTesting(index == cards.count - 1)
                    .accessibilityHidden(index < cards.count - 1)
            }
        }
    }
}

extension View {
    func stacked(for total: Int, at index: Int) -> some View {
        return self.offset(y: Double(total - index) * 10)
    }
}

// MARK: - PREVIEW
#Preview(traits: .sizeThatFitsLayout) {
    CardsStackView(
        cards: .constant(Array(repeating: .example, count: 10)),
        onRemove: {_ in}
    )
}
