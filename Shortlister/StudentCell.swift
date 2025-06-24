import UIKit

class StudentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var gpaLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    
    var onButtonTapped: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
//        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 2)
      }
    
//    override func prepareForReuse() {
//        nameLabel.text = nil
//        universityLabel.text = nil
//        gpaLabel.text = nil
//        skillsLabel.text = nil
//        actionButton.titleLabel?.text = nil
//    }
    
    @IBAction func handleButtonTap(_ sender: UIButton) {
        print("Tapped")
        if let name = nameLabel.text {
            onButtonTapped?(name)
        }
    }
    
}
