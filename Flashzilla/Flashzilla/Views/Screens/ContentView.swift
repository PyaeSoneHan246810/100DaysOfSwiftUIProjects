//
//  ContentView.swift
//  Flashzilla
//
//  Created by Dylan on 27/12/2024.
//

import SwiftUI

struct ContentView: View {
    // MARK: - ENVIRONMENT PROPERTIES
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled
    @Environment(\.scenePhase) private var scenePhase
    
    // MARK: - STATE PROPERTIES
    @State private var cards: [Card] = []
    @State private var isTimerActive: Bool = true
    @State private var timeRemaining: Int = 20
    @State private var isEditScreenPresented: Bool = false
    // MARK: - PROPERTIES
    let timerPublisher = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack(spacing: 2.0) {
                VStack(spacing: 2.0) {
                    Text("Flashzilla")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                    if timeRemaining > 0 {
                        Text("Time: \(timeRemaining)")
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .padding(.horizontal, 20.0)
                            .padding(.vertical, 4.0)
                            .background(.black.opacity(0.75))
                            .clipShape(.capsule)
                    }
                    if cards.isEmpty || timeRemaining <= 0 {
                        Button("Play again") {
                            resetCards()
                        }.buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                            .tint(.black)
                            .transition(.scale)
                    }
                }.foregroundStyle(.white)
                    .animation(.smooth, value: cards.count)
                CardsStackView(
                    cards: $cards,
                    onRemove: { index in
                        withAnimation {
                            removeCard(at: index)
                        }
                    }
                ).allowsHitTesting(timeRemaining > 0)
            }
            VStack(spacing: 2.0) {
                HStack {
                    Spacer()
                    Button {
                        isEditScreenPresented.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.largeTitle)
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                            .foregroundStyle(.white)
                    }
                }
            }.padding(20.0)
            if differentiateWithoutColor || voiceOverEnabled {
                accessibilityButtonsView
            }
        }
        .sheet(
            isPresented: $isEditScreenPresented,
            onDismiss: {
                resetCards()
            },
            content: EditCardsScreen.init
        )
        .onAppear {
            resetCards()
        }
        .onReceive(timerPublisher) { _ in
            guard isTimerActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                if cards.isEmpty == false {
                    isTimerActive = true
                }
            } else {
                isTimerActive = false
            }
        }
    }
    
    // MARK: - SUB VIEWS
    @ViewBuilder
    private var accessibilityButtonsView: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    withAnimation {
                        removeCard(at: cards.count - 1)
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .padding()
                        .background(.black.opacity(0.7))
                        .clipShape(.circle)
                }.accessibilityLabel("Wrong")
                    .accessibilityHint("Mark your answer as being incorrect")
                Spacer()
                Button {
                    withAnimation {
                        removeCard(at: cards.count - 1)
                    }
                } label: {
                    Image(systemName: "checkmark.circle")
                        .padding()
                        .background(.black.opacity(0.7))
                        .clipShape(.circle)
                }.accessibilityLabel("Correct")
                    .accessibilityHint("Mark your answer as being correct")
            }.foregroundStyle(.white)
                .font(.largeTitle)
                .padding()
        }.padding(.bottom, 30.0)
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
    private func removeCard(at index: Int) {
        guard index >= 0 else { return }
        cards.remove(at: index)
        if cards.isEmpty {
            isTimerActive = false
        }
    }
    private func resetCards() {
        loadCardsData()
        timeRemaining = 20
        isTimerActive = true
    }
}

// MARK: - PREVIEW
#Preview(traits: .sizeThatFitsLayout) {
    ContentView()
}
