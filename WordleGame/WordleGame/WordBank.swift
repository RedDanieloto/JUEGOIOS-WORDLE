//
//  WordBank.swift
//  WordleGame
//
//  Created by Daniel Cabrera on 3/21/25.
//

import Foundation
class WordBank {
    static let shared = WordBank()
    
    let words: [String] = [
        // Palabras de 5 letras
        "SOLAR", "CIELO", "FUEGO", "RUMBO", "TANGO", "MIRAR", "SALTO", "JUEGO", "NUBES", "CAMPO",
        // Palabras de 6 letras
        "CARTEL", "FLORES", "SOMBRA", "PUENTE", "CIEGAS", "MANTEL", "SILLAS", "JARDIN", "CABLES", "FRESAS",
        // Palabras de 7 letras
        "CAMINOS", "FIESTAS", "SOMBRAS", "PUENTES", "CIEGOS", "MANTLES", "SILLONS", "JARDINS", "CABLESS", "FRESCAS"
    ]
    
    func getRandomWord() -> String {
        return words.randomElement()!.uppercased()
    }
    
    func getRandomWordLength() -> Int {
        let lengths = [5, 6, 7]
        return lengths.randomElement()!
    }
}
