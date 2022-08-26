//: [Previous](@previous)

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

struct JSONObject: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

let loadJsonTask = URLSession.shared.dataTask(with: url) { data, res, err in
    if let err = err {
        print("Not able to loads the JSON: \(err.localizedDescription)")
        return
    }
    
    guard let res = res as? HTTPURLResponse, res.statusCode == 200 else {
        print("Wrong response code")
        return
    }
    
    if let data = data {
        do {
            let object = try JSONDecoder().decode([JSONObject].self, from: data)
            print(object[0])
        } catch {
            print(error)
        }
    }
    
    PlaygroundPage.current.finishExecution()
}

loadJsonTask.resume()


//: [Next](@next)
