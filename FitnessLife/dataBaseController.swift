//
//  dataBaseController.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/18/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

class dataBaseController: UIViewController {

    
    @IBOutlet weak var dataView: UITextView!
    @IBAction func requestButton(_ sender: UIButton) {
        APIManager.sharedInstance.getAllCoaches(onSuccess: { json in
            DispatchQueue.main.async {
                self.dataView?.text = String(describing: json)
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })
    }
    //    @IBAction func createTableButton(_ sender: UIButton) {
//        print("GET REQUEST")
//        
//        guard let url = URL(string: "http://localhost:3004/coaches") else {
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
//        
//    }
//    @IBAction func insertCoachButton(_ sender: UIButton) {
//        print("INSERT USER")
//        let alert = UIAlertController(title: "Insert coach", message: nil, preferredStyle: .alert)
//        alert.addTextField { (tf) in tf.placeholder = "Name" }
//        alert.addTextField { (tf) in tf.placeholder = "Email" }
//        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
//            guard let name = alert.textFields?.first?.text,
//                let email = alert.textFields?.last?.text else {return}
//            print(name)
//            print(email)
//        }
//        alert.addAction(action)
//        present(alert, animated: true, completion:  nil)
//    }
//    @IBAction func ListCoachButton(_ sender: UIButton) {
//        print("POST REQUEST")
//        
//        let param = ["firstName": "Alex",
//                     "lastName": "Don",
//                     "category": "dance",
//                     "experience": "8",
//                     "position": "personal coach"]
//        
//        guard let url = URL(string: "http://localhost:3004/coaches") else {
//            return
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: param, options: []) else {
//            return
//        }
//        request.httpBody = httpBody
//        
//        let session = URLSession.shared
//        session.dataTask(with: request){ (data, response, error) in
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
//            }.resume()
//    }
//    @IBAction func UpdateCoachButton(_ sender: UIButton) {
//        print("UPDATE USER")
//        let alert = UIAlertController(title: "Update coach", message: nil, preferredStyle: .alert)
//        alert.addTextField { (tf) in tf.placeholder = "Coach ID" }
//        alert.addTextField { (tf) in tf.placeholder = "Email" }
//        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
//            guard let coachID = alert.textFields?.first?.text,
//                let email = alert.textFields?.last?.text else {return}
//            print(coachID)
//            print(email)
//        }
//        alert.addAction(action)
//        present(alert, animated: true, completion:  nil)
//    }
//    @IBAction func deleteCoachButton(_ sender: UIButton) {
//        print("DELETE USER")
//        let alert = UIAlertController(title: "Delete coach", message: nil, preferredStyle: .alert)
//        alert.addTextField { (tf) in tf.placeholder = "Coach ID" }
//        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
//            guard let coachID = alert.textFields?.first?.text else {return}
//            print(coachID)
//        }
//        alert.addAction(action)
//        present(alert, animated: true, completion:  nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
