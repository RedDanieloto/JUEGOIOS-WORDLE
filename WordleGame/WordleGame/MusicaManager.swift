//
//  MusicaManager.swift
//  WordleGame
//
//  Created by mac on 25/03/25.
//

import UIKit
import AVFAudio

class MusicaManager: NSObject {

    static let shared = MusicaManager()
    var reproductorMusicaFondo: AVAudioPlayer?

    func iniciarMusica() {
        guard let url = Bundle.main.url(forResource: "menu", withExtension: "mp3") else { return }
        do {
            reproductorMusicaFondo = try AVAudioPlayer(contentsOf: url)
            reproductorMusicaFondo?.numberOfLoops = -1
            reproductorMusicaFondo?.play()
        } catch {
            print("No se encontró la canción")
        }
    }

    func detenerMusica() {
        reproductorMusicaFondo?.stop()
    }
    
}
