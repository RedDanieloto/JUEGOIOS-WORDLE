import UIKit

class GameViewController: UIViewController {
    
    // Outlets para la interfaz
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var gridView: UIStackView!
    
    // Outlets para los botones del teclado
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("gridView: \(gridView)")
        iniciarNuevoJuego()
        configurarTablero()
        configurarTeclado()
        iniciarTemporizador()
        actualizarInterfaz()
    }
    
    func iniciarNuevoJuego() {
        estadoJuego = GameState()
        print("estadoJuego inicializado: \(estadoJuego)")
        palabraActual = ""
    }
    
    func configurarTablero() {
        // Verificar que gridView no sea nil
        guard let tablero = gridView else {
            print("Error: gridView es nil. Por favor, revisa la conexión en el storyboard.")
            return
        }
        
        // Verificar que estadoJuego no sea nil
        guard let estado = estadoJuego else {
            print("Error: estadoJuego es nil. Asegúrate de inicializar estadoJuego antes de llamar a configurarTablero().")
            return
        }
        
        // Limpiar cualquier contenido previo en el tablero
        tablero.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Configurar el stack view principal
        tablero.axis = .vertical
        tablero.spacing = 5
        tablero.alignment = .center
        tablero.distribution = .equalSpacing
        
        // Generar 6 filas (máximo de intentos)
        for _ in 0..<estado.maxGuessesPerRound {
            let filaStackView = UIStackView()
            filaStackView.axis = .horizontal
            filaStackView.spacing = 5
            filaStackView.alignment = .center
            filaStackView.distribution = .equalSpacing
            
            // Generar celdas según la longitud de la palabra (5 a 7 letras)
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
        
        print("Tablero poblado con \(tablero.arrangedSubviews.count) filas")
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
                // Asignar tags programáticamente
                if indice < 27 {
                    boton.tag = indice + 1 // Tags 1 a 27 para las letras (Q, W, ..., M)
                } else if indice == 27 {
                    boton.tag = 100 // Tag 100 para Borrar
                } else if indice == 28 {
                    boton.tag = 101 // Tag 101 para Enviar
                }
                boton.addTarget(self, action: #selector(teclaPresionada(_:)), for: .touchUpInside)
                print("Botón \(etiquetasBotones[indice]) (índice \(indice)) conectado: \(boton) con tag: \(boton.tag)")
            } else {
                print("Botón \(etiquetasBotones[indice]) (índice \(indice)) es nil")
            }
        }
    }
    
    @objc func teclaPresionada(_ sender: UIButton) {
        print("Botón presionado con tag: \(sender.tag)")
        
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
        default:
            print("Tag desconocido: \(tag)")
            return
        }
        
        print("Tecla presionada: \(tecla)")
        
        if tecla == "⌫" {
            if !palabraActual.isEmpty {
                palabraActual.removeLast()
                print("Última letra borrada. Palabra actual: \(palabraActual)")
            }
        } else if tecla == "⏎" {
            print("Enviando intento: \(palabraActual)")
            enviarIntento()
        } else if palabraActual.count < estadoJuego.wordLength {
            palabraActual += tecla
            print("Añadida \(tecla). Palabra actual: \(palabraActual)")
        } else {
            print("No se puede añadir \(tecla). Límite de longitud alcanzado: \(palabraActual)")
        }
        
        actualizarInterfaz()
    }
    
    func enviarIntento() {
        guard palabraActual.count == estadoJuego.wordLength else { return }
        
        let resultado = estadoJuego.evaluateGuess(guess: palabraActual)
        estadoJuego.guesses[estadoJuego.currentGuess].letters = resultado
        estadoJuego.currentGuess += 1
        
        if palabraActual == estadoJuego.wordOfTheRound {
            estadoJuego.didWinRound = true
            estadoJuego.isGameOver = true
            finalizarRonda()
        } else if estadoJuego.currentGuess >= estadoJuego.maxGuessesPerRound {
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
        temporizador?.invalidate()
        if estadoJuego.lives <= 0 {
            mostrarFinJuego()
        } else {
            mostrarResultadoRonda()
        }
    }
    
    func mostrarResultadoRonda() {
        let mensaje = estadoJuego.didWinRound ? "¡Ganaste la ronda!" : "Perdiste la ronda. La palabra era: \(estadoJuego.wordOfTheRound)"
        let alerta = UIAlertController(title: "Ronda \(estadoJuego.currentRound)", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Siguiente Ronda", style: .default) { _ in
            self.estadoJuego.currentRound += 1
            self.iniciarNuevoJuego()
            self.configurarTablero()
            self.iniciarTemporizador()
            self.actualizarInterfaz()
        })
        present(alerta, animated: true)
    }
    
    func mostrarFinJuego() {
        let alerta = UIAlertController(title: "Juego Terminado", message: "Te quedaste sin vidas. Rondas alcanzadas: \(estadoJuego.currentRound)", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Volver al Menú", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        present(alerta, animated: true)
    }
    
    func actualizarInterfaz() {
        // Actualizar las vidas
        heart1.image = estadoJuego.lives >= 1 ? UIImage(named: "corazon") : UIImage(named: "blackheart")
        heart2.image = estadoJuego.lives >= 2 ? UIImage(named: "corazon") : UIImage(named: "blackheart")
        heart3.image = estadoJuego.lives >= 3 ? UIImage(named: "corazon") : UIImage(named: "blackheart")
        
        roundLabel.text = "Ronda: \(estadoJuego.currentRound)"
        timerLabel.text = "Tiempo: \(estadoJuego.timeRemaining)s"
        
        // Verificar que gridView no sea nil y tenga subviews
        guard let tablero = gridView, !tablero.arrangedSubviews.isEmpty else {
            print("Tablero es nil o está vacío, omitiendo actualización del tablero")
            return
        }
        
        print("Actualizando interfaz con palabraActual: \(palabraActual)")
        
        for fila in 0..<estadoJuego.maxGuessesPerRound {
            let filaStackView = tablero.arrangedSubviews[fila] as! UIStackView
            for columna in 0..<estadoJuego.wordLength {
                let etiqueta = filaStackView.arrangedSubviews[columna] as! UILabel
                if fila == estadoJuego.currentGuess && columna < palabraActual.count {
                    let letra = String(palabraActual[palabraActual.index(palabraActual.startIndex, offsetBy: columna)])
                    etiqueta.text = letra
                    etiqueta.backgroundColor = .lightGray
                    print("Colocando letra \(letra) en fila \(fila), columna \(columna)")
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
        
        // Actualizar el teclado
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
            for intento in estadoJuego.guesses where !intento.letters.allSatisfy({ $0.state == .unknown }) {
                if let estadoLetra = intento.letters.first(where: { $0.character == letra })?.state {
                    if estadoLetra == .correct {
                        estado = .correct
                        break
                    } else if estadoLetra == .present && estado != .correct {
                        estado = .present
                    } else if estadoLetra == .absent && estado == .unknown {
                        estado = .absent
                    }
                }
            }
            switch estado {
            case .correct:
                boton?.backgroundColor = .systemGreen
                boton?.isEnabled = true // Deshabilitar la tecla
            case .present:
                boton?.backgroundColor = .systemYellow
                boton?.isEnabled = true // Deshabilitar la tecla
            case .absent:
                boton?.backgroundColor = .darkGray
                boton?.isEnabled = false // Deshabilitar la tecla
            default:
                boton?.backgroundColor = .gray
                boton?.isEnabled = true // Habilitar la tecla si no ha sido usada
            }
        }
    }
}
