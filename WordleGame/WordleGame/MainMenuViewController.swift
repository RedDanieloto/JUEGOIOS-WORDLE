import UIKit

class MainMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toInstructions", sender: nil)
    }
    
    @IBAction func recordsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toRecords", sender: nil)
    }
    
    @IBAction func creditsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toCredits", sender: nil)
    }
}
