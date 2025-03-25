import UIKit

class SplashViewController: UIViewController {
    
    
    @IBOutlet weak var splashImagen: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarAnimacion()
    }
    
    func configurarAnimacion() {
        // Configurar estado inicial de la imagen
        
        splashImagen.alpha = 0.0
        splashImagen.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        // Animación: difuminado y escalado
        UIView.animate(withDuration: 2.0, animations: {
            self.splashImagen.alpha = 1.0
            self.splashImagen.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { _ in
            // Después de la animación, transicionar al menú
            self.performSegue(withIdentifier: "toMenuSegue", sender: nil)
        }
    }
}
