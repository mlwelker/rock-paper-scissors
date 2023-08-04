
import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var playerChoice: Move = .scissors {
        didSet {
            if gameIsOver {
                reset()
            }
        }
    }
    @Published var computerChoice: Move?
    @Published var gameIsOver: Bool = false
    @Published var outcome: Outcome?
    @Published var roundsLost = 0
    @Published var roundsWon = 0
    @Published var roundsTied = 0
    
    func endGame() {
        if !gameIsOver {
            let computer = Move.allCases.randomElement() ?? .scissors
            self.computerChoice = computer
            record(outcome: determinePlayerOutcome(player: playerChoice, computer: computer))
            gameIsOver = true
        } else {
            reset()
        }
    }
    
    func reset() {
        computerChoice = nil
        outcome = nil
        gameIsOver = false
    }

    enum Move: CaseIterable {
        case rock
        case paper
        case scissors
    }
    
    enum Outcome {
        case victory, defeat, tie
    }
    
    private func determinePlayerOutcome(player: Move, computer: Move) -> Outcome {
        switch (player, computer) {
        case (.rock, .rock), (.scissors, .scissors), (.paper, .paper):
            return .tie
        case (.rock, .paper), (.paper, .scissors), (.scissors, .rock):
            return .defeat
        case (.rock, .scissors), (.scissors, .paper), (.paper, .rock):
            return .victory
        }
    }
    
    private func record(outcome newOutcome: Outcome) {
        
        outcome = newOutcome
        
        switch newOutcome {
        case .victory:
            roundsWon += 1
        case .defeat:
            roundsLost += 1
        case .tie:
            roundsTied += 1
        }
    }
}

struct ContentView: View {
    
    @StateObject var viewModel: ViewModel = .init()
    
    @ViewBuilder
    func displayed(move: ViewModel.Move?) -> some View {
        Group {
            switch move {
            case .none:
                Text("?")
            case .rock:
                Text("✊")
            case .scissors:
                Text("✌️")
            case .paper:
                Text("🖐️")
            }
        }
        .font(.largeTitle)
    }
    
    var body: some View {
        Form {
            Section {
                Picker("Choose hand", selection: $viewModel.playerChoice) {
                    ForEach(ViewModel.Move.allCases, id: \.self) { move in
                        displayed(move: move)
                    }
                }
                .pickerStyle(.segmented) // is there a way to get any change in picker selection to also change another variable? in this case gameIsOver (maybe use didSet?)
            } header: {
                Text("Choose your hand")
            }
            
            Section {
                HStack {
                    Spacer()
                    VStack {
                        Text("Player")
                        displayed(move: viewModel.playerChoice)
                    }
                    Text("VS")
                    VStack {
                        Text("CPU")
                        displayed(move: viewModel.computerChoice)
                    }
                    Spacer()
                }
                .padding()
            } header: {
                Text("Matchup")
            }
            
            Section {
                VStack {
                    Button(action: viewModel.endGame) {
                        Text(viewModel.gameIsOver ? "Again?" : "GO!")
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
                    
                    Group {
                        switch viewModel.outcome {
                        case .none:
                            Text("...")
                        case .victory:
                            Text("You win!😎")
                        case .defeat:
                            Text("You lose!😭")
                        case .tie:
                            Text("Tie!🥱")
                        }
                    }
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
                        Text("\(viewModel.roundsWon)")
                    }
                    .modifier(SubtleText())
                    
                    Spacer()
                    
                    VStack {
                        Text("T")
                        Text("\(viewModel.roundsTied)")
                    }
                    .modifier(SubtleText())
                    
                    Spacer()
                    
                    VStack {
                        Text("L")
                        Text("\(viewModel.roundsLost)")
                    }
                    .modifier(SubtleText())
                    
                    Spacer()
                }
                .padding(5)
                
            } header: {
                Text("History")
            }
        }
    }
}

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
