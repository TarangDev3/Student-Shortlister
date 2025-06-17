import UIKit

class StudentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var gpaLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var onButtonTapped: ((String) -> Void)?
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        onButtonTapped?(nameLabel.text ?? "Student")
    }
}
