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
    
    var activityIndicator: UIActivityIndicatorView!

    
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
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        activityIndicator.startAnimating()

        
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
                    self?.activityIndicator.stopAnimating()
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
        
        cell.configure(with: student)
        
        cell.onButtonTapped = { [weak self] name in
            
            guard let self = self else { return }
            
            if !student.isShortlisted{
                student.isShortlisted = true
                self.myTableView.reloadRows(at: [indexPath], with: .none)

                let alert = UIAlertController(title: nil, message: "\(name) shortlisted", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        let visitAction = UIAction(title: "Visit GitHub", image: UIImage(systemName: "globe")) { _ in
            if let url = URL(string: student.github) {
                UIApplication.shared.open(url)
            }
        }

        let shareAction = UIAction(title: "Share Profile", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
            guard let self = self else { return }
            let profileInfo = "\(student.name)\n\(student.university)\nGPA: \(student.gpa)\nSkills: \(student.skills)"
            let activityVC = UIActivityViewController(activityItems: [profileInfo], applicationActivities: nil)
            self.present(activityVC, animated: true)
        }

        let menu = UIMenu(title: "", children: [visitAction, shareAction])
        cell.moreButton.menu = menu
        cell.moreButton.showsMenuAsPrimaryAction = true
        cell.moreButton.setTitle("More", for: .normal)


        
        return cell
    }
}
