import UIKit

class RecordsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let highestRound = UserDefaults.standard.integer(forKey: "highestRound")
        let label = UILabel()
        label.text = "Ronda más alta: \(highestRound)"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}
