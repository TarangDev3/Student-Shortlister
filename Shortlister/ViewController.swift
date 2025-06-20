//
//  ViewController.swift
//  Shortlister
//
//  Created by Tarang Sultania on 10/06/25.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    var students: [Student] = []
    var filteredStudents: [Student] = []
    
    enum GPASortState {
        case none
        case descending
        case ascending
    }
    var gpaSortState: GPASortState = .none

    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var subheadingLabel: UILabel!
    @IBOutlet var gpaButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBAction func gpaButtonTapped(_ sender: UIButton) {
        switch gpaSortState {
        case .none:
            filteredStudents.sort { $0.gpa > $1.gpa }
            gpaSortState = .descending
            gpaButton.setTitle("4-0", for: .normal)
            
        case .descending:
            filteredStudents.sort { $0.gpa < $1.gpa }
            gpaSortState = .ascending
            gpaButton.setTitle("0-4", for: .normal)
            
        case .ascending:
            filteredStudents = students
            gpaSortState = .none
            gpaButton.setTitle("GPA", for: .normal)
        }

        myTableView.reloadData()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        myTableView.delegate = self
        myTableView.dataSource = self
        
        headingLabel.text = "Swift Student Challenge"
        headingLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        subheadingLabel.text = "WWDC 2025"
        subheadingLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        fetchStudents()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        searchBar.backgroundImage = UIImage()

        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.clearButtonMode = .never
            textField.borderStyle = .roundedRect
            textField.layer.cornerRadius = 15
            textField.clipsToBounds = true
            textField.font = UIFont.systemFont(ofSize: 18)
            textField.textColor = .gray

            textField.frame.size.height = 40

        }
    }

    
    func fetchStudents() {
        guard let url = URL(string: "https://demo9847086.mockable.io/student") else {
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
                    self?.filteredStudents = decodedResponse.students
                    self?.myTableView.reloadData()
                }
            } catch {
                print("Decoding error:", error)
            }
        }
        
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredStudents = students
        } else {
            filteredStudents = students.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        myTableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = filteredStudents[indexPath.row]
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
