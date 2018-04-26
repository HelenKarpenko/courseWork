//
//  RestApiManager.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/19/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    let baseURL = "http://localhost:3004/"

//    func getRandomUser(onCompletion: (JSON) -> Void) {
//        let route = baseURL
//        makeHTTPGetRequest(route, onCompletion: { json, err in
//            onCompletion(json as JSON)
//        })
//    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        print("GET REQUEST")
//
//        guard let url = URL(string: baseURL + path) else {
//            return
//        }
//
//        let session = URLSession.shared
//        session.dataTask(with: url){ (data, response, error) in
//            if let response = response {
//                print(response)
//            }
//
//            if let data = data {
//                print(data)
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print(json)
//                } catch {
//                    print(error)
//                }
//            }
//        }.resume()
        
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data)
            onCompletion(json, error)
        })
        task.resume()
    }
}
