//
//  SplashViewController.swift
//  WordleGame
//
//  Created by Daniel Cabrera on 12/03/25.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var splashImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Escalado y difuminado
        splashImageView.alpha = 0.0
        splashImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 2.0, animations: {
            self.splashImageView.alpha = 1.0
            self.splashImageView.transform = .identity
        }) { _ in
            // Transición al menú después de la animación
            self.performSegue(withIdentifier: "toMenuSegue", sender: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
