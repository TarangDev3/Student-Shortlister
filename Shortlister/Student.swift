import Foundation

struct Student: Decodable {
    let name: String
    let university: String
    let gpa: Double
    let skills: String
    let github: String
//    var shortlisted: Bool = false
}

struct StudentsResponse: Decodable {
    let students: [Student]
}
