
import SwiftUI

struct SubtleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.gray)
    }
}

extension View {
    func subtle() -> some View {
        modifier(SubtleText())
    }
}

struct ContentView: View {
    let rps = ["✊", "🖐️", "✌️"]
    let victory = "You win!😎"
    let defeat = "You lose!😭"
    let tie = "Tie!🥱"
    
    @State private var playerChoice: String = "✌️"
    @State private var computerChoice: String = "✌️"
    @State private var reveal: Bool = false
    @State private var outcome = "..."
    @State private var roundsLost = 0
    @State private var roundsWon = 0
    @State private var roundsTied = 0
    
    func battleResult() {
        if !reveal {
            computerChoice = rps.randomElement() ?? "✌️"
            if playerChoice == computerChoice {
                outcome = tie
                roundsTied += 1
            } else if playerChoice == "✌️" && computerChoice == "🖐️" {
                outcome = victory
                roundsWon += 1
            } else if playerChoice == "✌️" && computerChoice == "✊" {
                outcome = defeat
                roundsLost += 1
            } else if playerChoice == "✊" && computerChoice == "🖐️" {
                outcome = defeat
                roundsLost += 1
            } else if playerChoice == "✊" && computerChoice == "✌️" {
                outcome = victory
                roundsWon += 1
            } else if playerChoice == "🖐️" && computerChoice == "✌️" {
                outcome = defeat
                roundsLost += 1
            } else if playerChoice == "🖐️" && computerChoice == "✊" {
                outcome = victory
                roundsWon += 1
            }
            reveal = true
        } else {
            outcome = "..."
            reveal = false
        }
    }
    
    var body: some View {
        Form {
            Section {
                Picker("Choose hand", selection: $playerChoice) {
                    ForEach(rps, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented) // is there a way to get any change in picker selection to also change another variable? in this case reveal (maybe use didSet?)
            } header: {
                Text("Choose your hand")
            }
            
            Section {
                HStack {
                    Spacer()
                    VStack {
                        Text("Player")
                        Text("\(playerChoice)")
                            .font(.largeTitle)
                    }
                    Text("VS")
                    VStack {
                        Text("CPU")
                        Text(reveal ? "\(computerChoice)" : "?")
                            .font(.largeTitle)
                    }
                    Spacer()
                }
                .padding()
            } header: {
                Text("Matchup")
            }
            
            Section {
                VStack {
                    Button(action: battleResult) {
                        Text(reveal ? "Again?" : "GO!")
                            .frame(maxWidth: .infinity, minHeight: 50) // why does order matter here? minHeight first doesn't work
                    }
                    .buttonStyle(.borderedProminent)
                }
            } header: {
                Text("Battle!")
            }
            
            Section {
                HStack {
                    Spacer()
                    Text(outcome)
                        .font(.largeTitle)
                    Spacer()
                }
            } header: {
                Text("Result")
            }
            
            Section {
                HStack {
                    Spacer()
                    VStack {
                        Text("W")
                        Text("\(roundsWon)")
                    }
                    .subtle()
                    Spacer()
                    VStack {
                        Text("T")
                        Text("\(roundsTied)")
                    }
                    .subtle()
                    Spacer()
                    VStack {
                        Text("L")
                        Text("\(roundsLost)")
                    }
                    .subtle()
                    Spacer()
                }
                .padding(5)
            } header: {
                Text("History")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
