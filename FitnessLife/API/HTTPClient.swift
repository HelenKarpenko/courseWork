//
//  APIManager.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/20/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit
//import Alamofire

// Singleton
class HTTPClient: NSObject {

    let baseURL = "http://localhost:3000"
    static let shared = HTTPClient()
    static let getCoachesEndpoint = "/coaches/"
    static let getLessonsPrototypeEndpoint = "/lessonsPrototype/"
    static let getClientsEndpoint = "/clients/"
    
    
    func GET(path: String,
             onSuccess: @escaping (Data) -> Void,
             onFailure: @escaping (Error) -> Void) {
        let urlString : String = baseURL + path
        guard let url = URL(string: urlString) else {
            fatalError("Unable to convert \(urlString) to URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                onFailure(error)
                return
            }

            if let data = data {
                onSuccess(data)
            }
        }
        task.resume()
    }

    func POST(path: String,
              params: [String: Any],
              onSuccess: @escaping (Data) -> Void,
              onFailure: @escaping (Error) -> Void) {

        let urlString : String = baseURL + path
        guard let url = URL(string: urlString) else {
            fatalError("Unable to convert \(urlString) to URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        request.httpBody = httpBody

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                onFailure(error)
                return
            }

            if let data = data {
                onSuccess(data)
            }
        }
        task.resume()
    }

    func DELETE(path: String,
              onSuccess: @escaping () -> Void,
              onFailure: @escaping (Error) -> Void) {

        let urlString : String = baseURL + path
        guard let url = URL(string: urlString) else {
            fatalError("Unable to convert \(urlString) to URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                onFailure(error)
                return
            }
            onSuccess()
        }
        task.resume()
    }

    func PUT(path: String,
              params: [String: Any],
              onSuccess: @escaping (Data) -> Void,
              onFailure: @escaping (Error) -> Void) {

        let urlString : String = baseURL + path
        guard let url = URL(string: urlString) else {
            fatalError("Unable to convert \(urlString) to URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        request.httpBody = httpBody

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                onFailure(error)
                return
            }

            if let data = data {
                onSuccess(data)
            }
        }
        task.resume()
    }

    func getAllCoaches(onSuccess: @escaping ([Coach]) -> Void,
                       onFailure: @escaping (Error) -> Void){
//        let path : String = HTTPClient.getCoachesEndpoint
//        GET(path: path,
//            onSuccess: { data in
//                do {
//                    let coaches = try JSONDecoder().decode([Coach].self, from: data)
//                    onSuccess(coaches)
//                } catch {
//                    onFailure(error)
//                }
//        },
//            onFailure: { error in
//                onFailure(error)
//
//        })
    }

    func postCoach(params: [String: Any],
                   onSuccess: @escaping (Coach) -> Void,
                   onFailure: @escaping (Error) -> Void){
//        let path : String = HTTPClient.getCoachesEndpoint
//        POST(path: path,
//             params: params,
//             onSuccess: { data in
//                do {
//                    let coach = try JSONDecoder().decode(Coach.self, from: data)
//                    onSuccess(coach)
//                } catch {
//                    onFailure(error)
//                }
//        },
//             onFailure: { error in
//                onFailure(error)
//        })
    }

    func deleteCoach(id: Int,
                    onSuccess: @escaping () -> Void,
                    onFailure: @escaping (Error) -> Void){
//        let path : String = HTTPClient.getCoachesEndpoint + String(id)
//        DELETE(path: path,
//               onSuccess: onSuccess,
//               onFailure: { error in
//                onFailure(error)
//        })
    }

    func getCoachWithId(id: Int,
                        onSuccess: @escaping(Coach) -> Void,
                        onFailure: @escaping(Error) -> Void){
//        let path : String = HTTPClient.getCoachesEndpoint + String(id)
//        GET(path: path,
//            onSuccess: { data in
//                do {
//                    let coach = try JSONDecoder().decode(Coach.self, from: data)
//                    onSuccess(coach)
//                } catch {
//                    onFailure(error)
//                }
//        },
//            onFailure: { error in
//                onFailure(error)
//        })
    }


    func getAllLessons(onSuccess: @escaping ([Lesson]) -> Void,
                       onFailure: @escaping (Error) -> Void){
//        let path : String = HTTPClient.getLessonsPrototypeEndpoint
//        GET(path: path,
//            onSuccess: { data in
//                do {
//                    let lessons = try JSONDecoder().decode([Lesson].self, from: data)
//                    onSuccess(lessons)
//                } catch {
//                    onFailure(error)
//                }
//        },
//            onFailure: { error in
//                onFailure(error)
//        })
    }

    func getLessonById(id: Int,
                       onSuccess: @escaping (Lesson) -> Void,
                       onFailure: @escaping (Error) -> Void){
//        let path : String = HTTPClient.getLessonsPrototypeEndpoint + String(id)
//        GET(path: path,
//            onSuccess: { data in
//                do {
//                    let lesson = try JSONDecoder().decode(Lesson.self, from: data)
//                    onSuccess(lesson)
//                } catch {
//                    onFailure(error)
//                }
//        },
//            onFailure: { error in
//                onFailure(error)
//        })
    }

    func getAllClients(onSuccess: @escaping ([IClient]) -> Void,
                       onFailure: @escaping (Error) -> Void){
//        let path : String = HTTPClient.getClientsEndpoint
//        GET(path: path,
//            onSuccess: { data in
//                do {
//                    let clients = try JSONDecoder().decode([Client].self, from: data)
//                    onSuccess(clients)
//                } catch {
//                    onFailure(error)
//                }
//        },
//            onFailure: { error in
//                onFailure(error)
//        })
    }

//    func postClient(params: [String: Any],
//                   onSuccess: @escaping (Client) -> Void,
//                   onFailure: @escaping (Error) -> Void){
//        let path : String = HTTPClient.getClientsEndpoint
//        POST(path: path,
//             params: params,
//             onSuccess: { data in
//                do {
//                    let client = try JSONDecoder().decode(Client.self, from: data)
//                    onSuccess(client)
//                } catch {
//                    onFailure(error)
//                }
//        },
//             onFailure: { error in
//                onFailure(error)
//
//        })
//    }

//    func postScheduleItem(params: [String: Any],
//                    onSuccess: @escaping (Client) -> Void,
//                    onFailure: @escaping (Error) -> Void){
//        let path : String = HTTPClient.getClientsEndpoint
//        POST(path: path,
//             params: params,
//             onSuccess: { data in
//                do {
//                    let client = try JSONDecoder().decode(Client.self, from: data)
//                    onSuccess(client)
//                } catch {
//                    onFailure(error)
//                }
//        },
//             onFailure: { error in
//                onFailure(error)
//
//        })
//    }
//}

}
