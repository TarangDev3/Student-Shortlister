import Foundation

struct Student: Decodable {
    let name: String
    let university: String
    let gpa: Double
    let skills: String
}

struct StudentsResponse: Decodable {
    let students: [Student]
}
