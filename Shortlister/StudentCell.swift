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
        selectionStyle = .none      }
    
    override func prepareForReuse() {
       super.prepareForReuse()
       actionButton.setTitle("Shortlist", for: .normal)
       actionButton.backgroundColor = .systemBlue
       actionButton.setTitleColor(.white, for: .normal)
       actionButton.isEnabled = true
       actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
   }
    
    @IBAction func handleButtonTap(_ sender: UIButton) {
        print("Tapped")
        if let name = nameLabel.text {
            onButtonTapped?(name)
        }
    }
    
    func configure(with student: Student) {
        nameLabel.text = student.name
        universityLabel.text = student.university
        gpaLabel.text = "\(student.gpa)"
        skillsLabel.text = student.skills

        if student.isShortlisted {
            actionButton.setTitle("Shortlisted", for: .normal)
            actionButton.backgroundColor = .lightGray
            actionButton.setTitleColor(.white, for: .normal)
            actionButton.isEnabled = false
        } else {
            actionButton.setTitle("Shortlist", for: .normal)
            actionButton.backgroundColor = .systemBlue
            actionButton.setTitleColor(.white, for: .normal)
            actionButton.isEnabled = true
        }

        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
}
