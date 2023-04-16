//
//  Model.swift
//  Swagger
//
//  Created by MAC13 on 13.04.2023.
//

import Alamofire
import Foundation
import Kingfisher
import UIKit

var items: [Content] = []
private let serverEndpoint = "https://junior.balinasoft.com"
private let name = "Nesterovich Vladzimir Vladzimirovich"

func loadContent(competionHandler: (() -> Void)?) {
    let url = URL(string: serverEndpoint + "/api/v2/photo/type")!
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        if let response = try? JSONDecoder().decode(MyResponse.self, from: data) {
            DispatchQueue.main.async {
                items.removeAll()
                items.append(contentsOf: response.content)
                print("Loaded \(response.content.count) items")
                competionHandler?()
            }
        }
    }.resume()
}

func postImage(image: UIImage, id: Int) {
    guard let url = URL(string: serverEndpoint + "/api/v2/photo") else {
        print("Invalid URL")
        return
    }
    if let imageData = image.jpegData(compressionQuality: 1.0) {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
            multipartFormData.append("\(id)".data(using: .utf8)!, withName: "typeId")
            multipartFormData.append(name.data(using: .utf8)!, withName: "name")
        }, to: url)
        .responseDecodable(of: Response.self) { response in
            switch response.result {
            case .success(let response):
            print("ID: \(response.id)")
            case .failure(let error):
            print("Error: \(error.localizedDescription)")
            }
        }
    } else {
        print("Failed to create image data")
    }
}
