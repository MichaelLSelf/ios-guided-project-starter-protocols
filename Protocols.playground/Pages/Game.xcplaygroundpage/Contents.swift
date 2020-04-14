import Foundation
//: We're building a dice game called _Knock Out!_. It is played using the following rules:
//: 1. Each player chooses a “knock out number” – either 6, 7, 8, or 9. More than one player can choose the same number.
//: 2. Players take turns throwing both dice, once each turn. Add the number of both dice to the player's running score.
//: 3. If a player rolls their own knock out number, they are knocked out of the game.
//: 4. Play ends when either all players have been knocked out, or if a single player scores 100 points or higher.
//:
//: Let's reuse some of the work we defined from the previous page.

protocol GeneratesRandomNumbers {
    func random() -> Int
}

class OneThroughTen: GeneratesRandomNumbers {
    func random() -> Int {
        return Int.random(in: 1...10)
    }
}

class Dice {
    let sides: Int
    let generator: GeneratesRandomNumbers
    
    init(sides: Int, generator: GeneratesRandomNumbers) {
        self.sides = sides
        self.generator = generator
    }
    
    func roll() -> Int {
        return Int(generator.random() % sides) + 1
    }
}

//: Now, let's define a couple protocols for managing a dice-based game.
protocol DiceGame {
    var dice: Dice {get}
    func play()
}

protocol DiceGameDelegate {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}


//: Lastly, we'll create a custom class for tracking a player in our dice game.

class Player {
    let id: Int
    let knockOutNumber: Int = Int.random(in: 6...9)
    var score: Int = 0
    var knockedOut: Bool = false
    
    init(id: Int) {
        self.id = id
        
    }
}

//: With all that configured, let's build our dice game class called _Knock Out!_

class KnockOut: DiceGame {
    var dice: Dice
    var players: [Player] = []
    
    init(numberOfPlayers: Int) {
        for i in 1...numberOfPlayers {
            let aPlayer = Player(id: i)
            players.append(aPlayer)
        }
    }

    var delegate: DiceGameDelegate
    
    func play() {
        delegate.gameDidStart(self)
        
        
        var reachedGameEnd = false
        while !reachedGameEnd {
            for player in players where player.knockedOut == false {
                
                
                // rolling the dice
                let diceRollSum = dice.roll() + dice.roll()
                
                // check knockout number
                if diceRollSum == player.knockOutNumber {
                    print("player \(player.id) is knocked out by rolling \(player.knockOutNumber)")
                }
                // if it is knockout goodbye player
                
                player.knockedOut = true
                let activePlayers = players.filter( {$0.knockedOut == false})
                if activePlayers.count == 0 {
                    print("all players have been knocked out")
                
            } else {
                // if not add the score to the running score
                player.score += diceRollSum
                if player.score >= 100 {
                    reachedGameEnd = true
                    print("Player \(player.id) has won with a score of \(player.score)")
                    }
                // game end
                // all players are
                // or when a player reaches 100 sore
            
                
            }
        }
    }
}

//: The following class is used to track the status of the above game, and will conform to the `DiceGameDelegate` protocol.
class DiceGameTracker: DiceGameDelegate {
    func gameDidStart(_ game: DiceGame) {
        numberOfTurn = 0
        if game is KnockOut {
            print(" started a new game of Knock Out")
        }
        print(" the game is using a \(game.dice.sides)-sided dice")
    }
    
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurn += 1
        print("Rolled a \(diceRoll)")
    }
    
    func gameDidEnd(_ game: DiceGame) {
        print("The Game lasted for \(numberOfTurn) turns")
    }
    
    
}


//: Finally, we need to test out our game. Let's create a game instance, add a tracker, and instruct the game to play.

let tracker = DiceGameTracker()

let game = KnockOut(numberOfPlayers: 5)
    
    
game.delegate = tracker
