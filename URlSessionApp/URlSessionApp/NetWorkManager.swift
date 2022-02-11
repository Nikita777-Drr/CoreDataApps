//
//  NetWorkManager.swift
//  URlSessionApp
//
//  Created by User on 08.02.2022.
//

import UIKit


class NetworkManager{
    static func createURLRequestGet(forURL url:String){
        guard let url = URL(string: url)  else {return}
        let session = URLSession.shared
        session.dataTask(with: url) {(data, responce, error) in
            guard let responce = responce, let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch  {
                print(error.localizedDescription)
            }
        }.resume()
    }
    static func createURLRequestPost(forURL url:String){
        guard let url = URL(string: url)  else {return}
        let userData = ["Course":"Networking", "lesson":"Get and Post Request"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else {return}
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in
            guard let responce = responce, let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch  {
                print(error.localizedDescription)
            }
        }.resume()
    }
    static func networkAction(url:String, compitionHandler: @escaping (_ image:UIImage)->()) {
       
        guard let url = URL(string: url) else {return}
        let session = URLSession.shared
        session.dataTask(with: url) {(data, response, error) in
            if let data = data, let image = UIImage(data: data){
                DispatchQueue.main.async {
                    compitionHandler(image)
                }
            }
        }.resume()
    }
    
    static func fetchData(_ url:String, completionHandler:@escaping(_ courses:[ModelCourses])->()){
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) {(data, responce, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode([ModelCourses].self, from: data)
                completionHandler(courses)
            } catch let error {
                print("Error", error)
            }
        }.resume()
    }
   
}
