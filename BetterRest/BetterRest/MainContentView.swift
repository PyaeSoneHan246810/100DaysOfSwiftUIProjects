import SwiftUI
import CoreML

struct MainContentView: View {
    @State private var wakeUpTime = defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var recommendedBedTime = Date.now
    @State private var isBedTimePresented = false
    @State private var alertTitle  = ""
    @State private var alertMessage = ""
    @State private var isAlertPresented = false
    
    private static var defaultWakeUpTime: Date {
        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 0
        return Calendar.current.date(from: dateComponents) ?? Date.now
    }
    
    var body: some View {
        NavigationStack {
            VStack(
                alignment: .center
            ) {
                Form {
                    Section {
                        VStack(
                            alignment: .leading,
                            spacing: 12
                        ) {
                            Text("When would you like to wake up?")
                                .font(.headline.weight(.semibold))
                            DatePicker("Please enter a time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        VStack(
                            alignment: .leading,
                            spacing: 12
                        ) {
                            Text("What is your desired amount of sleep?")
                                .font(.headline.weight(.semibold))
                            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4.0...12.0, step: 0.5)
                        }
                        VStack(
                            alignment: .leading,
                            spacing: 12
                        ) {
                            Text("What is your daily coffee intake?")
                                .font(.headline.weight(.semibold))
                            Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20, step: 1)
                        }.frame(maxWidth: .infinity)
                    }
                    Section {
                        VStack(
                            alignment: .leading,
                            spacing: 12
                        ) {
                            Text("Recommended Bedtime")
                                .font(.headline.weight(.semibold))
                            if isBedTimePresented {
                                Text(recommendedBedTime.formatted(date: .omitted, time: .shortened))
                                    .font(.title.bold())
                            } else {
                                Text("Click Calclulate")
                                    .font(.callout)
                            }
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .navigationTitle("Better Rest")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button("Calculate") {
                        calculateBedtime()
                    }.buttonStyle(.borderless)
                }
                .alert(alertTitle, isPresented: $isAlertPresented) {
                    Button("Ok") {
                        
                    }
                } message: {
                    Text(alertMessage)
                }
        }
    }
    
    private func calculateBedtime() {
        do {
            let mlModelConfig = MLModelConfiguration()
            let sleepCalculator = try SleepCalculator(configuration: mlModelConfig)
            let dateComponents  = Calendar.current.dateComponents(Set([.hour, .minute]), from: wakeUpTime)
            let wakeUpHourInSeconds = (dateComponents.hour ?? 0) * 60 * 60
            let wakeUpMinuteInSeconds = (dateComponents.minute ?? 0) * 60
            let prediction = try sleepCalculator.prediction(wake: Double(wakeUpHourInSeconds + wakeUpMinuteInSeconds), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            recommendedBedTime = wakeUpTime - prediction.actualSleep
            isBedTimePresented = true
            alertTitle = "Your ideal bedtime is"
            alertMessage = recommendedBedTime.formatted(date: .omitted, time: .shortened)
        } catch {
            isBedTimePresented = false
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        isAlertPresented = true
    }
}

#Preview {
    MainContentView()
}
