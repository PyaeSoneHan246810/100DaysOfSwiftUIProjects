import SwiftUI

struct MainContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer  = Int.random(in: 0...2)
    @State private var showScoreAlert = false
    @State private var scoreAlertTitle = ""
    @State private var score = 0
    @State private var questionCount = 0
    @State private var showFinalAlert = false
    @State private var correctRotationAmount = 0.0
    @State private var correctOpacityAmount = 1.0
    @State private var incorrectOpacityAmount = 1.0
    @State private var correctScaleAmount = 1.0
    @State private var incorrectScaleAmount = 1.0
    var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(color: .orange, location: 0),
                    .init(color: .red, location: 0.4)
                ],
                center: .top,
                startRadius: 200,
                endRadius: 600
            )
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .foregroundStyle(.white)
                    .font(.largeTitle.bold())
                VStack(
                    spacing: 20
                ) {
                    VStack(
                        spacing: 4
                    ) {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.primary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                                .rotation3DEffect(.degrees(number == correctAnswer ? correctRotationAmount : 0.0), axis: (x: 1, y: 1, z: 0))
                                .opacity(number == correctAnswer ? correctOpacityAmount : incorrectOpacityAmount)
                                .scaleEffect(number == correctAnswer ? correctScaleAmount : incorrectScaleAmount)
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.thinMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                    .padding(.horizontal, 20)
                Spacer()
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
        }.ignoresSafeArea()
            .alert(
                scoreAlertTitle,
                isPresented: $showScoreAlert
            ) {
                Button("Continue") {
                    continueGame()
                }
            } message: {
                Text("Your current score is \(score).")
            }
            .alert(
                "Game Finished",
                isPresented: $showFinalAlert
            ) {
                Button("Restart") {
                    restartGame()
                }
            } message: {
                Text("Your total score is \(score).")
            }
    }
    
    private func flagTapped(_ number: Int) {
        questionCount += 1
        if questionCount >= 8 {
            showFinalAlert = true
            showScoreAlert = false
        } else {
            showFinalAlert = false
            showScoreAlert = true
        }
        if number == correctAnswer {
            correctRotationAmount = 360
            correctOpacityAmount = 1.0
            incorrectOpacityAmount = 0.5
            correctScaleAmount = 1.0
            incorrectScaleAmount = 0.8
            scoreAlertTitle = "Correct"
            score += 1
        } else {
            correctOpacityAmount = 1.0
            incorrectOpacityAmount = 0.5
            correctScaleAmount = 1.0
            incorrectScaleAmount = 0.8
            scoreAlertTitle = "Wrong! That's the flag of \(countries[number])"
        }
    }
    
    private func continueGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        showScoreAlert = false
        scoreAlertTitle = ""
        showFinalAlert = false
        correctRotationAmount = 0
        correctOpacityAmount = 1.0
        incorrectOpacityAmount = 1.0
        correctScaleAmount = 1.0
        incorrectScaleAmount = 1.0
    }
    
    private func restartGame() {
        continueGame()
        score = 0
        questionCount = 0
    }
}

struct FlagImage: View {
    var country: String
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 4)
    }
}

#Preview {
    MainContentView()
}
