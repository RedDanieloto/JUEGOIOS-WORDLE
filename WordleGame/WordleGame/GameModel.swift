//
//  GameModel.swift
//  WordleGame
//
//  Created by Daniel Cabrera on 3/21/25.
//

import Foundation

enum LetterState {
    case correct   // Verde
    case present   // Amarillo
    case absent    // Gris
    case unknown   // Antes de evaluar
}

struct Letter {
    let character: String
    var state: LetterState
}

struct Guess {
    var letters: [Letter]
}

class GameState {
    let wordLength: Int
    var wordOfTheRound: String
    var guesses: [Guess] = []
    var currentGuess: Int = 0
    var lives: Int = 3
    var currentRound: Int = 1
    var maxGuessesPerRound: Int = 6
    var timeRemaining: Int = 60 // 60 segundos por ronda
    var isGameOver: Bool = false
    var didWinRound: Bool = false
    
    init() {
        self.wordLength = WordBank.shared.getRandomWordLength()
        self.wordOfTheRound = WordBank.shared.getRandomWord()
        // Asegurarse de que la palabra tenga la longitud seleccionada
        while self.wordOfTheRound.count != self.wordLength {
            self.wordOfTheRound = WordBank.shared.getRandomWord()
        }
        // Inicializar las filas vacías según la longitud de la palabra
        for _ in 0..<maxGuessesPerRound {
            let emptyGuess = Guess(letters: (0..<wordLength).map { _ in Letter(character: "", state: .unknown) })
            guesses.append(emptyGuess)
        }
    }
    
    func evaluateGuess(guess: String) -> [Letter] {
        let guessArray = Array(guess.uppercased())
        let targetArray = Array(wordOfTheRound)
        var result: [Letter] = []
        
        // Contar las letras en la palabra objetivo
        var targetLetterCount = [Character: Int]()
        for char in targetArray {
            targetLetterCount[char, default: 0] += 1
        }
        
        // Evaluar cada letra
        for i in 0..<guessArray.count {
            let char = guessArray[i]
            if char == targetArray[i] {
                result.append(Letter(character: String(char), state: .correct))
                targetLetterCount[char]! -= 1
            } else if targetLetterCount[char] != nil && targetLetterCount[char]! > 0 {
                result.append(Letter(character: String(char), state: .present))
                targetLetterCount[char]! -= 1
            } else {
                result.append(Letter(character: String(char), state: .absent))
            }
        }
        
        return result
    }
}
