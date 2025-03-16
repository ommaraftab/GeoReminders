//
//  NetworkingService.swift
//  GeoReminders
//
//  Created by Developer on 15/03/2025.
//

import Foundation

class NetworkingService {
    func fetchLocations(completion: @escaping (Result<[Location], Error>) -> Void) {
        let urlString = "https://ommaraftab.github.io/SampleJSON/LocationSample.json"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let locations = try JSONDecoder().decode([Location].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(locations))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
