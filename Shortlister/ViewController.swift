//
//  ViewController.swift
//  Shortlister
//
//  Created by Tarang Sultania on 10/06/25.
//

import UIKit

class ViewController: UIViewController {
    
    var students: [Student] = []
    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var subheadingLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myTableView.delegate = self
        myTableView.dataSource = self
        
        headingLabel.text = "Swift Student Challenge"
        headingLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        subheadingLabel.text = "WWDC 2025"
        subheadingLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        headerView.layoutIfNeeded()
        
        myTableView.tableHeaderView = headerView
        
        fetchStudents()
    }
    
    func fetchStudents() {
            guard let url = URL(string: "https://run.mocky.io/v3/bb3289ea-2131-4ade-bcb4-a06ed487120a") else {
                print("Invalid URL")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    print("API Error:", error)
                    return
                }
                
                guard let data = data else {
                    print("No data received from API")
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(StudentsResponse.self, from: data)
                    DispatchQueue.main.async {
                        self?.students = decodedResponse.students
                        self?.myTableView.reloadData()
                    }
                } catch {
                    print("Decoding error:", error)
                }
            }
            
            task.resume()
        }
}




extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = students[indexPath.row]
        let cell = myTableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! StudentCell
        cell.nameLabel.text = "\(student.name)"
        cell.universityLabel.text = "\(student.university)"
        cell.gpaLabel.text = "\(student.gpa)"
        cell.skillsLabel.text = "\(student.skills)"
        
        cell.actionButton.backgroundColor = .systemBlue
        cell.actionButton.setTitle("Shortlist", for: .normal)

        cell.onButtonTapped = { [weak self] name in
            
            guard let self = self else { return }
            
            cell.actionButton.backgroundColor = .lightGray
            cell.actionButton.setTitle("Shortlisted", for: .normal)
            
            let alert = UIAlertController(title: nil, message: "\(name) shortlisted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }

        
        return cell
    }
}
