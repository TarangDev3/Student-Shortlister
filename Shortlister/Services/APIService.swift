

import Foundation

protocol APIServiceProtocol {
    func fetchStudents(completion: @escaping (Result<[Student], Error>) -> Void)
}

class APIService: APIServiceProtocol {
    func fetchStudents(completion: @escaping (Result<[Student], Error>) -> Void) {
        guard let url = URL(string: "https://demo9847086.mockable.io/student") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 404)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(StudentsResponse.self, from: data)
                completion(.success(decoded.students))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
