//
//  ViewController.swift
//  Shortlister
//
//  Created by Tarang Sultania on 27/06/25.
//

import Foundation
import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet var myTableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var subheadingLabel: UILabel!
    @IBOutlet var gpaButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!

    var activityIndicator: UIActivityIndicatorView!
    let viewModel = StudentListViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        myTableView.delegate = self
        myTableView.dataSource = self
        searchBar.delegate = self

        viewModel.onDataChanged = { [weak self] in
            self?.gpaButton.setTitle(self?.viewModel.gpaButtonTitle(), for: .normal)
            self?.myTableView.reloadData()
            self?.activityIndicator.stopAnimating()
        }

        activityIndicator.startAnimating()
        viewModel.fetchStudents()
    }
    
    

    private func setupUI() {
        headingLabel.text = "Swift Student Challenge"
        headingLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        subheadingLabel.text = "WWDC 2025"
        subheadingLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)

        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    @IBAction func gpaButtonTapped(_ sender: UIButton) {
        viewModel.sortGPA()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterStudents(query: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.backgroundImage = UIImage()
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.borderStyle = .roundedRect
            textField.layer.cornerRadius = 15
            textField.font = UIFont.systemFont(ofSize: 18)
            textField.textColor = .gray
            textField.frame.size.height = 40
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredStudents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = viewModel.filteredStudents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! StudentCell
        cell.configure(with: student)

        cell.onButtonTapped = { [weak self] in
            self?.viewModel.toggleShortlist(for: indexPath.row)
            let alert = UIAlertController(title: nil, message: "\(student.name) shortlisted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }

        
        let visitAction = UIAction(title: "Visit GitHub", image: UIImage(systemName: "globe")) { _ in
            if let url = URL(string: student.github) {
                UIApplication.shared.open(url)
            }
        }
        let shareAction = UIAction(title: "Share Profile", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
            let info = "\(student.name)\n\(student.university)\nGPA: \(student.gpa)\nSkills: \(student.skills)"
            let vc = UIActivityViewController(activityItems: [info], applicationActivities: nil)
            self?.present(vc, animated: true)
        }
        let menu = UIMenu(title: "", children: [visitAction, shareAction])
        cell.moreButton.menu = menu
        cell.moreButton.showsMenuAsPrimaryAction = true
        cell.moreButton.setTitle("More", for: .normal)

        return cell
    }
}
