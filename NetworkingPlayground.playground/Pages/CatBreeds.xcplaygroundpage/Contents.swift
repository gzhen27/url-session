//: [Previous](@previous)

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct CatBreed: Codable, CustomStringConvertible {
    let id: String
    let name: String
    let temperament: String
    let lifeSpan: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, temperament
        case lifeSpan = "life_span"
    }

    var description: String {
        return """
        -----------Cat Info-------------
        id: \(id)
        name: \(name)
        termperament: \(temperament)
        life span: \(lifeSpan)
        --------------------------------
        """
    }
}

//let url = URL(string: "https://api.thecatapi.com/v1/breeds")!
let url = URL(string: "https://api.thecatapi.com/v1/breeds?limit=2")!
let request = URLRequest(url: url)
let decoder = JSONDecoder()

let breedTask = URLSession.shared.dataTask(with: request) { data, res, err in
    if let err = err {
        print("Not able to loads the breeds: \(err.localizedDescription)")
        return
    }
    
    guard let res = res as? HTTPURLResponse, (200...299).contains(res.statusCode) else {
        print("Wrong status code")
        return
    }
    
    guard let breedData = data else {
        print("No data returned")
        return
    }
    
    do {
        let breeds = try decoder.decode([CatBreed].self, from: breedData)
        breeds.forEach { print($0) }
    } catch {
        print("Failed to decode the data: \(error)")
    }
    
    PlaygroundPage.current.finishExecution()
}

breedTask.resume()

//: [Next](@next)
