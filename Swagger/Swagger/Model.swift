//
//  Model.swift
//  Swagger
//
//  Created by MAC13 on 13.04.2023.
//

import Foundation
import UIKit
import Kingfisher
import Alamofire

struct MyResponse: Codable {
    let content: [Content]
    let page: Int?
    let pageSize: Int?
    let totalElements: Int?
    let totalPages: Int?
}

struct Content: Codable {
    let id: Int?
    let name: String?
    let image: String?
}


var items: [Content] = []


func loadContent(competionHandler: (()->Void)?) {
    let url = URL(string: "https://junior.balinasoft.com/api/v2/photo/type")!
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        
        if let response = try? JSONDecoder().decode(MyResponse.self, from: data) {
            DispatchQueue.main.async {
                items.append(contentsOf: response.content)
                print("Item count: \(items.count)")
                print("Loaded \(response.content.count) items")
                competionHandler?()
            }
        }
        
    }.resume()
}

func getImage(url: String?, imageView: UIImageView) {
    if let url = URL(string: url ?? "11") {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                if image!.size.height > 100 && image!.size.width > 100 {
                    DispatchQueue.main.async {
                        imageView.kf.setImage(with: url)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(named: "eraser")
                    }
                }
            }
        }.resume()
    } else {
        DispatchQueue.main.async {
            imageView.image = UIImage(systemName: "eraser")
        }
    }

}

func postImage(image: UIImage) {
    let url = URL(string: "https://junior.balinasoft.com/api/v2/photo")
    let stageImage = UIImage(systemName: "eraser")
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let body = NSMutableData()
    let name = "Nester"
    let typeId = "1"
    let imageData = image.jpegData(compressionQuality: 1.0) ?? stageImage!.jpegData(compressionQuality: 1.0)
    
    
    // Add name parameter to body
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(name)\r\n".data(using: .utf8)!)

    // Add typeId parameter to body
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"typeId\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(typeId)\r\n".data(using: .utf8)!)

    // Add photo parameter to body
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    body.append(imageData!)
    body.append("\r\n".data(using: .utf8)!)

    // Close body
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
    request.httpBody = body as Data
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        guard response is HTTPURLResponse
              //(200...299).contains(response.statusCode) else
        else {
            print("Server error")
            return
        }
        if let data = data {
               
                print("Response: \(String(data: data, encoding: .utf8) ?? "")")
            
        }
    }
    task.resume()
}



//func loadContent() {
//    let url = URL(string: "https://junior.balinasoft.com/api/v2/photo/type")!
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//
//    URLSession.shared.dataTask(with: request) { data, response, error in
//        guard let data = data, error == nil else {
//            return
//        }
//
//        do {
//            let responseJSON = try JSONDecoder().decode(MyResponse.self, from: data)
//            item += responseJSON.content
//        } catch let error {
//            print(error.localizedDescription)
//        }
//
//    }.resume()
//}
//
//func loadContent(){
//    let url = URL(string:"https://junior.balinasoft.com/v2/api-docs?group=api2")!
//
//    var request = URLRequest(url:url)
//    request.httpMethod = "GET"
//
//    URLSession.shared.dataTask(with: request) { data, response, error in
//        guard let data = data, error == nil
//        else {
//            return
//        }
//    //try JSONDecoder().decode(MyResponse.self, from: data)
////        do {
////            let jsonResult = try JSONDecoder().decode(MyResponse.self, from: data)
////
////            item = jsonResult.content
////            complitionHandler?()
////        }
////        catch {
////                print(error)
////        }
//        guard let responseJSON = try? JSONDecoder().decode(MyResponse.self, from: data) else {
//            return
//        }
//
//        for element in responseJSON {
//            print("Append")
//            item.append(element as! MyResponse)
//        }
//
//    }.resume()
//}
