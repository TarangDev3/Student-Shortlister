import Foundation

class StudentListViewModel {
    enum GPASortState {
        case none, ascending, descending
    }

    private(set) var students: [Student] = []
    private(set) var filteredStudents: [Student] = []
    private(set) var gpaSortState: GPASortState = .none
    
    private let service: APIServiceProtocol
    var onDataChanged: (() -> Void)?

    init(service: APIServiceProtocol = APIService()) {
        self.service = service
    }

    func fetchStudents() {
        service.fetchStudents { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let students):
                    self?.students = students
                    self?.filteredStudents = students
                    self?.onDataChanged?()
                case .failure(let error):
                    print("API Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func filterStudents(query: String) {
        filteredStudents = query.isEmpty
            ? students
            : students.filter { $0.name.lowercased().contains(query.lowercased()) }
        onDataChanged?()
    }

    func toggleShortlist(for index: Int) {
        filteredStudents[index].isShortlisted = true
        onDataChanged?()
    }

    func sortGPA() {
        switch gpaSortState {
        case .none:
            filteredStudents.sort { $0.gpa > $1.gpa }
            gpaSortState = .descending
        case .descending:
            filteredStudents.sort { $0.gpa < $1.gpa }
            gpaSortState = .ascending
        case .ascending:
            filteredStudents = students
            gpaSortState = .none
        }
        onDataChanged?()
    }

    func gpaButtonTitle() -> String {
        switch gpaSortState {
        case .none: return "GPA"
        case .descending: return "4-0"
        case .ascending: return "0-4"
        }
    }
}
