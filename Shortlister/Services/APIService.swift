

import Foundation

protocol APIServiceProtocol {
    func fetchStudents(completion: @escaping (Result<[Student], Error>) -> Void)
    func updateShortlistStatus(for student: Student, completion: @escaping (Result<Bool, Error>) -> Void)
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
    
    func updateShortlistStatus(for student: Student, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "https://demo9847086.mockable.io/student_shortlist") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body: [String: Any] = [
            "data": ["isShortlisted": true]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                completion(.success(true))
            } else {
                completion(.failure(NSError(domain: "Invalid response", code: 500)))
            }
        }.resume()
    }

}
