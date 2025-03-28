import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    @IBOutlet weak var heart1: UIImageView?
    @IBOutlet weak var heart2: UIImageView?
    @IBOutlet weak var heart3: UIImageView?
    @IBOutlet weak var roundLabel: UILabel?
    @IBOutlet weak var timerLabel: UILabel?
    @IBOutlet weak var scoreLabel: UILabel?
    @IBOutlet weak var gridView: UIStackView?
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var buttonQ: UIButton!
    @IBOutlet weak var buttonW: UIButton!
    @IBOutlet weak var buttonE: UIButton!
    @IBOutlet weak var buttonR: UIButton!
    @IBOutlet weak var buttonT: UIButton!
    @IBOutlet weak var buttonY: UIButton!
    @IBOutlet weak var buttonU: UIButton!
    @IBOutlet weak var buttonI: UIButton!
    @IBOutlet weak var buttonO: UIButton!
    @IBOutlet weak var buttonP: UIButton!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonS: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    @IBOutlet weak var buttonF: UIButton!
    @IBOutlet weak var buttonG: UIButton!
    @IBOutlet weak var buttonH: UIButton!
    @IBOutlet weak var buttonJ: UIButton!
    @IBOutlet weak var buttonK: UIButton!
    @IBOutlet weak var buttonL: UIButton!
    @IBOutlet weak var buttonN: UIButton!
    @IBOutlet weak var buttonZ: UIButton!
    @IBOutlet weak var buttonX: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonV: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonN2: UIButton!
    @IBOutlet weak var buttonM: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonEnter: UIButton!
    
    var estadoJuego: GameState!
    var palabraActual: String = ""
    var temporizador: Timer?
    var reproductorSonido: AVAudioPlayer?
    var reproductorMusicaFondo: AVAudioPlayer?
    var musicaActivada: Bool = true
    var puntuacionAcumulada: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarMusicaFondo()
        iniciarNuevoJuego()
        configurarTablero()
        configurarTeclado()
        iniciarTemporizador()
        actualizarInterfaz()
        
        musicButton.setImage(UIImage(systemName: "apple.haptics.and.music.note"), for: .normal)
        musicButton.addTarget(self, action: #selector(alternarMusica), for: .touchUpInside)
        
        exitButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        exitButton.addTarget(self, action: #selector(salirDelJuego), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if musicaActivada, reproductorMusicaFondo != nil {
            reproductorMusicaFondo?.play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reproductorMusicaFondo?.pause()
    }
    
    func configurarMusicaFondo() {
        guard let url = Bundle.main.url(forResource: "natanael", withExtension: "mp3") else { return }
        do {
            reproductorMusicaFondo = try AVAudioPlayer(contentsOf: url)
            reproductorMusicaFondo?.numberOfLoops = -1
            reproductorMusicaFondo?.play()
        } catch {}
    }
    
    @objc func alternarMusica() {
        musicaActivada.toggle()
        if musicaActivada {
            reproductorMusicaFondo?.play()
            musicButton.setImage(UIImage(systemName: "apple.haptics.and.music.note"), for: .normal)
        } else {
            reproductorMusicaFondo?.pause()
            musicButton.setImage(UIImage(systemName: "apple.haptics.and.music.note.slash"), for: .normal)
        }
    }
    
    @objc func salirDelJuego() {
        temporizador?.invalidate()
        reproductorMusicaFondo?.pause()
        MusicaManager.shared.iniciarMusica()
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func iniciarNuevoJuego(restablecerVidas: Bool = true, restablecerRonda: Bool = true) {
        let vidasActuales = estadoJuego?.lives ?? 3
        let rondaActual = estadoJuego?.currentRound ?? 1
        MusicaManager.shared.detenerMusica()
        
        estadoJuego = GameState()
        if !restablecerVidas {
            estadoJuego.lives = vidasActuales
        } else {
            estadoJuego.lives = 3
        }
        if !restablecerRonda {
            estadoJuego.currentRound = rondaActual
        }
        
        if restablecerVidas && restablecerRonda {
            puntuacionAcumulada = 0
        }
        palabraActual = ""
    }
    
    func configurarTablero() {
        guard let tablero = gridView, let estado = estadoJuego else { return }
        tablero.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        tablero.axis = .vertical
        tablero.spacing = 5
        tablero.alignment = .center
        tablero.distribution = .equalSpacing
        
        for _ in 0..<estado.maxGuessesPerRound {
            let filaStackView = UIStackView()
            filaStackView.axis = .horizontal
            filaStackView.spacing = 5
            filaStackView.alignment = .center
            filaStackView.distribution = .equalSpacing
            
            for _ in 0..<estado.wordLength {
                let etiquetaLetra = UILabel()
                etiquetaLetra.text = ""
                etiquetaLetra.textAlignment = .center
                etiquetaLetra.backgroundColor = .lightGray
                etiquetaLetra.textColor = .white
                etiquetaLetra.font = .systemFont(ofSize: 20, weight: .bold)
                etiquetaLetra.layer.borderColor = UIColor.black.cgColor
                etiquetaLetra.layer.borderWidth = 1
                etiquetaLetra.layer.cornerRadius = 5
                etiquetaLetra.clipsToBounds = true
                etiquetaLetra.widthAnchor.constraint(equalToConstant: 50).isActive = true
                etiquetaLetra.heightAnchor.constraint(equalToConstant: 50).isActive = true
                filaStackView.addArrangedSubview(etiquetaLetra)
            }
            tablero.addArrangedSubview(filaStackView)
        }
    }
    
    func configurarTeclado() {
        let botones = [
            buttonQ, buttonW, buttonE, buttonR, buttonT, buttonY, buttonU, buttonI, buttonO, buttonP,
            buttonA, buttonS, buttonD, buttonF, buttonG, buttonH, buttonJ, buttonK, buttonL, buttonN,
            buttonZ, buttonX, buttonC, buttonV, buttonB, buttonN2, buttonM, buttonDelete, buttonEnter
        ]
        
        let etiquetasBotones = [
            "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P",
            "A", "S", "D", "F", "G", "H", "J", "K", "L", "Ñ",
            "Z", "X", "C", "V", "B", "N", "M", "Borrar", "Enviar"
        ]
        
        for (indice, boton) in botones.enumerated() {
            if let boton = boton {
                if indice < 27 {
                    boton.tag = indice + 1
                } else if indice == 27 {
                    boton.tag = 100
                } else if indice == 28 {
                    boton.tag = 101
                }
                boton.addTarget(self, action: #selector(teclaPresionada(_:)), for: .touchUpInside)
            }
        }
    }
    
    @objc func teclaPresionada(_ sender: UIButton) {
        let tag = sender.tag
        let tecla: String
        
        switch tag {
        case 1: tecla = "Q"
        case 2: tecla = "W"
        case 3: tecla = "E"
        case 4: tecla = "R"
        case 5: tecla = "T"
        case 6: tecla = "Y"
        case 7: tecla = "U"
        case 8: tecla = "I"
        case 9: tecla = "O"
        case 10: tecla = "P"
        case 11: tecla = "A"
        case 12: tecla = "S"
        case 13: tecla = "D"
        case 14: tecla = "F"
        case 15: tecla = "G"
        case 16: tecla = "H"
        case 17: tecla = "J"
        case 18: tecla = "K"
        case 19: tecla = "L"
        case 20: tecla = "Ñ"
        case 21: tecla = "Z"
        case 22: tecla = "X"
        case 23: tecla = "C"
        case 24: tecla = "V"
        case 25: tecla = "B"
        case 26: tecla = "N"
        case 27: tecla = "M"
        case 100: tecla = "⌫"
        case 101: tecla = "⏎"
        default: return
        }
        
        if tecla == "⌫" {
            if !palabraActual.isEmpty {
                palabraActual.removeLast()
            }
        } else if tecla == "⏎" {
            enviarIntento()
        } else if palabraActual.count < estadoJuego.wordLength {
            palabraActual += tecla
        }
        actualizarInterfaz()
    }
    
    func enviarIntento() {
        guard palabraActual.count == estadoJuego.wordLength else {
            let alerta = UIAlertController(title: "Palabra Incompleta", message: "Debes ingresar una palabra de \(estadoJuego.wordLength) letras.", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alerta, animated: true)
            return
        }
        
        let resultado = estadoJuego.evaluateGuess(guess: palabraActual)
        estadoJuego.guesses[estadoJuego.currentGuess].letters = resultado
        estadoJuego.currentGuess += 1
        
        if palabraActual == estadoJuego.wordOfTheRound {
            reproducirSonido("correcto")
            estadoJuego.didWinRound = true
            estadoJuego.isGameOver = true
            finalizarRonda()
        } else if estadoJuego.currentGuess >= estadoJuego.maxGuessesPerRound {
            reproducirSonido("error")
            estadoJuego.lives -= 1
            estadoJuego.isGameOver = true
            finalizarRonda()
        }
        
        palabraActual = ""
        actualizarInterfaz()
    }
    
    func iniciarTemporizador() {
        temporizador = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.estadoJuego.timeRemaining -= 1
            self.actualizarInterfaz()
            if self.estadoJuego.timeRemaining <= 0 {
                self.estadoJuego.lives -= 1
                self.estadoJuego.isGameOver = true
                self.finalizarRonda()
            }
        }
    }
    
    func finalizarRonda() {
        
        //aqui puedo configurar la puntuacion para q no suba cada q se finaliza la ronda
        
        
        temporizador?.invalidate()
        
        
        print("vidas:")
        print(estadoJuego.lives)
        
        print("Estado del juego:")
        print(estadoJuego.didWinRound)
        
        // puedo hacer q la puntiacion acumulada no llegue a cero y cada q finalice ronda si gano le sume puntos, si perdio q reste puntos sin pasarse a los negativos
        var puntuacionRonda = 0
        if(estadoJuego.didWinRound){//si gano se suma puntos segun la ronda actual
            puntuacionRonda = (estadoJuego.timeRemaining * 10) + (estadoJuego.currentRound * 100)
        }else{
            puntuacionRonda = -(estadoJuego.timeRemaining * 10) + -(estadoJuego.currentRound * 100)
        }
   
        puntuacionAcumulada += puntuacionRonda
        
        
        if estadoJuego.lives <= 0 {
            mostrarFinJuego(puntuacion: puntuacionAcumulada)
        } else {
            mostrarResultadoRonda()
        }
    }
    
    func mostrarResultadoRonda() {
        let mensaje: String
        if estadoJuego.didWinRound {
            mensaje = "¡Ganaste la ronda!"
            estadoJuego.currentRound += 1
        } else {
            mensaje = "Perdiste la ronda. La palabra era: \(estadoJuego.wordOfTheRound)"
        }
        
        let alerta = UIAlertController(title: "Ronda \(estadoJuego.currentRound)", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Continuar", style: .default, handler: { resp in
            //respuesta al darle continuar cuando pierde la partida o gana
            if(resp.isEnabled){
                print("Se presiono el boton de continuar")
                self.iniciarNuevoJuego(restablecerVidas: false, restablecerRonda: false)
                self.configurarTablero()
                self.iniciarTemporizador()
                self.actualizarInterfaz()
            }
        }))
        present(alerta, animated: true)
    }
    
    func mostrarFinJuego(puntuacion: Int) {
        var records = cargarRecords()
        if records.count < 5 || puntuacion > records.last!.puntuacion {
            let alerta = UIAlertController(title: "¡Nuevo Récord!", message: "Has entrado en el Top 5 con \(puntuacion) puntos. Ingresa tu nombre:", preferredStyle: .alert)
            alerta.addTextField { textField in
                textField.placeholder = "Tu nombre"
            }
            let accionGuardar = UIAlertAction(title: "Guardar", style: .default) { _ in
                let nombre = alerta.textFields?.first?.text ?? "Jugador"
                records.append(Record(nombre: nombre, puntuacion: puntuacion))
                records.sort { $0.puntuacion > $1.puntuacion }
                records = Array(records.prefix(5))
                self.guardarRecords(records)
                self.regresarAlMenuPrincipal()
            }
            let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel) { _ in
                self.regresarAlMenuPrincipal()
            }
            alerta.addAction(accionGuardar)
            alerta.addAction(accionCancelar)
            present(alerta, animated: true)
        } else {
            let alerta = UIAlertController(title: "Juego Terminado", message: "Te quedaste sin vidas. Rondas alcanzadas: \(self.estadoJuego.currentRound). Puntuación: \(puntuacion)", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Volver al Menú", style: .default) { _ in
                self.regresarAlMenuPrincipal()
            })
            present(alerta, animated: true)
        }
    }
    
    func regresarAlMenuPrincipal() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func actualizarInterfaz() {
        guard let estadoJuego = estadoJuego else { return }
        
        heart1?.image = estadoJuego.lives >= 1 ? UIImage(named: "corazon") : UIImage(named: "blackheart")
        heart2?.image = estadoJuego.lives >= 2 ? UIImage(named: "corazon") : UIImage(named: "blackheart")
        heart3?.image = estadoJuego.lives >= 3 ? UIImage(named: "corazon") : UIImage(named: "blackheart")
        
        roundLabel?.text = "Ronda: \(estadoJuego.currentRound)"
        timerLabel?.text = "Tiempo: \(estadoJuego.timeRemaining)s"
        
        let puntuacionRonda = (estadoJuego.timeRemaining * 10) + (estadoJuego.currentRound * 100)
        scoreLabel?.text = "Puntuación: \(puntuacionAcumulada + puntuacionRonda)"
        
        guard let tablero = gridView, !tablero.arrangedSubviews.isEmpty else { return }
        
        for fila in 0..<estadoJuego.maxGuessesPerRound {
            let filaStackView = tablero.arrangedSubviews[fila] as! UIStackView
            for columna in 0..<estadoJuego.wordLength {
                let etiqueta = filaStackView.arrangedSubviews[columna] as! UILabel
                if fila == estadoJuego.currentGuess && columna < palabraActual.count {
                    let letra = String(palabraActual[palabraActual.index(palabraActual.startIndex, offsetBy: columna)])
                    etiqueta.text = letra
                    etiqueta.backgroundColor = .lightGray
                } else if fila < estadoJuego.currentGuess {
                    let letra = estadoJuego.guesses[fila].letters[columna]
                    etiqueta.text = letra.character
                    switch letra.state {
                    case .correct:
                        etiqueta.backgroundColor = .systemGreen
                    case .present:
                        etiqueta.backgroundColor = .systemYellow
                    case .absent:
                        etiqueta.backgroundColor = .darkGray
                    default:
                        etiqueta.backgroundColor = .lightGray
                    }
                } else {
                    etiqueta.text = ""
                    etiqueta.backgroundColor = .lightGray
                }
            }
        }
        
        let botones = [
            (buttonQ, "Q"), (buttonW, "W"), (buttonE, "E"), (buttonR, "R"), (buttonT, "T"),
            (buttonY, "Y"), (buttonU, "U"), (buttonI, "I"), (buttonO, "O"), (buttonP, "P"),
            (buttonA, "A"), (buttonS, "S"), (buttonD, "D"), (buttonF, "F"), (buttonG, "G"),
            (buttonH, "H"), (buttonJ, "J"), (buttonK, "K"), (buttonL, "L"), (buttonN, "Ñ"),
            (buttonZ, "Z"), (buttonX, "X"), (buttonC, "C"), (buttonV, "V"), (buttonB, "B"),
            (buttonN2, "N"), (buttonM, "M")
        ]
        
        for (boton, letra) in botones {
            var estado: LetterState = .unknown

            
            for intento in estadoJuego.guesses where !intento.letters.allSatisfy({ $0.state == .unknown }){
                
                for letter in intento.letters where letter.character == letra{
                    if letter.state == .correct{
                        estado = .correct
                        break
                    } else if letter.state == .present && estado != .correct{
                        estado = .present
                    } else if letter.state == .absent && estado != .present{
                        print("La letra \(letra) no esta en la palabra")
                        estado = .absent
                    }
                }
                
                if estado == .correct{
                    break
                }
                
            }
            
            
            switch estado {
            case .correct:
                boton?.backgroundColor = .systemGreen
                boton?.isEnabled = true
            case .present:
                boton?.backgroundColor = .systemYellow
                boton?.isEnabled = true
            case .absent:
                boton?.backgroundColor = .darkGray
                boton?.isEnabled = false
            default:
                boton?.backgroundColor = .gray
                boton?.isEnabled = true
            }
        }
    }
    
    func reproducirSonido(_ nombreArchivo: String) {
        guard let url = Bundle.main.url(forResource: nombreArchivo, withExtension: "mp3") else { return }
        do {
            reproductorSonido = try AVAudioPlayer(contentsOf: url)
            reproductorSonido?.play()
        } catch {}
    }
    
    func obtenerRutaPlist() -> URL {
        let directorioDocumentos = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return directorioDocumentos.appendingPathComponent("Records.plist")
    }
    
    func cargarRecords() -> [Record] {
        let ruta = obtenerRutaPlist()
        if !FileManager.default.fileExists(atPath: ruta.path) {
            if let rutaBundle = Bundle.main.url(forResource: "Records", withExtension: "plist") {
                try? FileManager.default.copyItem(at: rutaBundle, to: ruta)
            } else {
                let recordsIniciales = [
                    Record(nombre: "Jugador 1", puntuacion: 1000),
                    Record(nombre: "Jugador 2", puntuacion: 800),
                    Record(nombre: "Jugador 3", puntuacion: 600),
                    Record(nombre: "Jugador 4", puntuacion: 400),
                    Record(nombre: "Jugador 5", puntuacion: 200)
                ]
                if let datos = try? PropertyListEncoder().encode(recordsIniciales) {
                    try? datos.write(to: ruta)
                }
                return recordsIniciales
            }
        }
        
        if let datos = try? Data(contentsOf: ruta),
           let recordsCargados = try? PropertyListDecoder().decode([Record].self, from: datos) {
            return recordsCargados
        }
        
        let recordsIniciales = [
            Record(nombre: "Jugador 1", puntuacion: 1000),
            Record(nombre: "Jugador 2", puntuacion: 800),
            Record(nombre: "Jugador 3", puntuacion: 600),
            Record(nombre: "Jugador 4", puntuacion: 400),
            Record(nombre: "Jugador 5", puntuacion: 200)
        ]
        if let datos = try? PropertyListEncoder().encode(recordsIniciales) {
            try? datos.write(to: ruta)
        }
        return recordsIniciales
    }
    
    func guardarRecords(_ records: [Record]) {
        let ruta = obtenerRutaPlist()
        if let datos = try? PropertyListEncoder().encode(records) {
            try? datos.write(to: ruta)
        }
    }
}
