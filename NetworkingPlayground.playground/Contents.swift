import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    ///extends as needed
}

let imageUrl = URL(string: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg")!

var request = URLRequest(url: imageUrl)
request.httpMethod = HTTPMethod.get.rawValue

let imageTask = URLSession.shared.dataTask(with: imageUrl) { imageData, res, err in
    if let err = err {
        print("Not able to fetch the image data: \(err.localizedDescription)")
        return
    }
    
    guard let res = res as? HTTPURLResponse, (200...299).contains(res.statusCode) else {
        /// please properly handles the errors based on the status code.
        print("Server Error: Please try again later!")
        return
    }
    
    if let data = imageData, let image = UIImage(data: data) {
        print("Fetched the image successfully!")
        let cat = image
        print(cat)
    }
}

imageTask.resume()
