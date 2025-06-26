import Foundation

class Student: Decodable {
    let name: String
    let university: String
    let gpa: Double
    let skills: String
    let github: String
    var isShortlisted: Bool = false

    enum CodingKeys: String, CodingKey {
        case name, university, gpa, skills, github
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        university = try container.decode(String.self, forKey: .university)
        gpa = try container.decode(Double.self, forKey: .gpa)
        skills = try container.decode(String.self, forKey: .skills)
        github = try container.decode(String.self, forKey: .github)
        // isShortlisted stays default `false`
    }
}

struct StudentsResponse: Decodable {
    let students: [Student]
}
