import UIKit

class RecordsViewController: UIViewController {
    
    @IBOutlet weak var etiquetaRecord1: UILabel!
    @IBOutlet weak var etiquetaRecord2: UILabel!
    @IBOutlet weak var etiquetaRecord3: UILabel!
    @IBOutlet weak var etiquetaRecord4: UILabel!
    @IBOutlet weak var etiquetaRecord5: UILabel!
    
    var records: [Record] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarRecords()
        mostrarRecords()
    }
    
    func obtenerRutaPlist() -> URL {
        let directorioDocumentos = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return directorioDocumentos.appendingPathComponent("Records.plist")
    }
    
    func cargarRecords() {
        let ruta = obtenerRutaPlist()
        if FileManager.default.fileExists(atPath: ruta.path) {
            if let datos = try? Data(contentsOf: ruta) {
                if let recordsCargados = try? PropertyListDecoder().decode([Record].self, from: datos) {
                    records = recordsCargados
                    return
                }
            }
        }
        // Si no hay récords, inicializar con valores falsos
        records = [
            Record(nombre: "Jugador 1", puntuacion: 1000),
            Record(nombre: "Jugador 2", puntuacion: 800),
            Record(nombre: "Jugador 3", puntuacion: 600),
            Record(nombre: "Jugador 4", puntuacion: 400),
            Record(nombre: "Jugador 5", puntuacion: 200)
        ]
    }
    
    func mostrarRecords() {
        let etiquetas = [etiquetaRecord1, etiquetaRecord2, etiquetaRecord3, etiquetaRecord4, etiquetaRecord5]
        for (indice, record) in records.prefix(5).enumerated() {
            etiquetas[indice]?.text = "\(indice + 1). \(record.nombre): \(record.puntuacion)"
        }
    }
}
