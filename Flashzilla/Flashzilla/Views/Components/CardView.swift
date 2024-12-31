//
//  CardView.swift
//  Flashzilla
//
//  Created by Dylan on 27/12/2024.
//

import SwiftUI

struct CardView: View {
    // MARK: - ENVIRONMENT PROPERTIES
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled
    // MARK: - PROPERTIES
    let card: Card
    var onRemove: (() -> Void)? = nil
    // MARK: - STATE PROPERTIES
    @State private var isAnswerVisible: Bool = false
    @State private var offset: CGSize = CGSize.zero
    // MARK: - BODY
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(
                    differentiateWithoutColor
                    ? Color.white
                    : Color.white.opacity(1.0 - Double(abs(offset.width / 50)))
                )
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25.0)
                        .fill(
                            offset.width > 0 ? Color.green : Color.red
                        )
                    
                )
                .shadow(radius: 10.0)
            VStack {
                if voiceOverEnabled {
                    Text(isAnswerVisible ? card.answer : card.prompt)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.black)
                } else {
                    Text(card.prompt)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.black)
                    if isAnswerVisible {
                        Text(card.answer)
                            .font(.system(.title, design: .rounded, weight: .medium))
                            .foregroundStyle(Color.black.opacity(0.70))
                            .transition(.scale)
                    }
                }
            }.multilineTextAlignment(.center)
                .padding(20.0)
                .animation(.bouncy(duration: 0.25), value: isAnswerVisible)
        }.frame(width: 450.0, height: 250.0)
            .rotationEffect(.degrees(offset.width / 5.0))
            .offset(x: offset.width * 2.0)
            .opacity(2 - Double(abs(offset.width / 50)))
            .animation(.spring(duration: 0.25), value: offset)
            .accessibilityAddTraits(.isButton)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { _ in
                        if abs(offset.width) > 100 {
                            onRemove?()
                        } else {
                            offset = .zero
                        }
                    }
            )
            .gesture(
                TapGesture()
                    .onEnded {
                        isAnswerVisible.toggle()
                    }
            )
    }
}

// MARK: - PREVIEW
#Preview(traits: .sizeThatFitsLayout) {
    CardView(
        card: .example
    )
}
