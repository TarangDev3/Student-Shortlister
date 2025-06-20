import UIKit

class StudentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var gpaLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var onButtonTapped: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
      }
    
    @IBAction func handleButtonTap(_ sender: UIButton) {
        print("Tapped")
        if let name = nameLabel.text {
            onButtonTapped?(name)
        }
    }
}
