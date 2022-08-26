//: [Previous](@previous)

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct BreedImage: Codable {
    let id: String
    let url: String
    let width: Int
    let height: Int
}

struct CatBreed: Codable, CustomStringConvertible {
    let id: String
    let name: String
    let temperament: String
    let lifeSpan: String
    let isHairless: Bool
    let image: BreedImage
    
    // need to call init to assgin the value properly because hairless is an Int from the CatAPI, but we want it to be Bool.
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        temperament = try values.decode(String.self, forKey: .temperament)
        lifeSpan = try values.decode(String.self, forKey: .lifeSpan)
        image = try values.decode(BreedImage.self, forKey: .image)
        
        let hairless = try values.decode(Int.self, forKey: .isHairless)
        isHairless = hairless == 1
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, temperament, image
        case lifeSpan = "life_span"
        case isHairless = "hairless"
    }

    var description: String {
        return """
        \n
        >--------------Cat Info----------------<
        \n
        id: \(id)
        name: \(name)
        termperament: \(temperament)
        life span: \(lifeSpan)
        is hairlesss: \(isHairless)
        imageURL: \(image.url)
        \n
        >--------------------------------------<
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
