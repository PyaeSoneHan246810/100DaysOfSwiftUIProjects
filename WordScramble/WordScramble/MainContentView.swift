import SwiftUI

struct MainContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var isErrorAlertPresented = false
    var body: some View {
        NavigationStack {
            VStack(
                alignment: .leading
            ) {
                TextField(
                    "Enter your word",
                    text: $newWord
                ).padding(.horizontal, 20)
                    .textInputAutocapitalization(.never)
                    .onSubmit {
                        addNewWord()
                    }
                List(
                    usedWords,
                    id: \.self
                ) { word in
                    HStack {
                        Image(systemName: "\(word.count).circle")
                        Text(word)
                    }.listRowSeparator(.hidden)
                }.listStyle(.plain)
                Text("Your Score: \(score)")
                    .font(.title2.bold())
                    .padding(.horizontal, 20)
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .navigationTitle(rootWord)
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    Button("Restart") {
                        startGame()
                    }
                }
                .alert(errorTitle, isPresented: $isErrorAlertPresented) {

                } message: {
                     Text(errorMessage)
                }
        }.onAppear {
            startGame()
        }
    }
    
    private func startGame() {
        getRootWord()
        usedWords.removeAll()
        score = 0
    }
    
    private func getRootWord() {
        if let startTxtUrl = Bundle.main.url(forResource: "start", withExtension: ".txt") {
            if let startWords = try? String(contentsOf: startTxtUrl) {
                let allWords = startWords.components(separatedBy: .newlines)
                rootWord = allWords.randomElement() ?? "apple"
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    private func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {
            presentWordErrorAlert(
                title: "Empty Word",
                message: "Please enter a word."
            )
            return
        }
        guard answer.count >= 3 else {
            presentWordErrorAlert(
                title: "Invalid Word",
                message: "Please enter a word not shorter than three letters."
            )
            return
        }
        guard answer != rootWord else {
            presentWordErrorAlert(
                title: "Invalid Word",
                message: "You can't just enter the given word."
            )
            return
        }

        guard isNotUsed(word: answer) else {
            presentWordErrorAlert(
                title: "Used Word",
                message: "Your word is already used."
            )
            return
        }
        guard isPossible(word: answer) else {
            presentWordErrorAlert(
                title: "Impossible Word",
                message: "You can't spell \"\(answer)\" from \"\(rootWord)\"."
            )
            return
        }
        guard isRealWord(word: answer) else {
            presentWordErrorAlert(
                title: "Unrecognized Word",
                message: "You can't just make up words."
            )
            return
        }
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        score += answer.count
        newWord = ""
    }
    
    private func isNotUsed(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    private func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    private func isRealWord(word: String) -> Bool {
        let textChecker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = textChecker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    private func presentWordErrorAlert(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        isErrorAlertPresented = true
    }
}

#Preview {
    MainContentView()
}
