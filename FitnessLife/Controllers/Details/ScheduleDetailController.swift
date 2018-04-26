//
//  ScheduleDetailController.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/16/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

class ScheduleDetailController: UIViewController {
    
    @IBOutlet weak var freePlacesCntLabel: UILabel!
    @IBOutlet weak var coachLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func registerButton(_ sender: Any) {
        print("REGISTER")
        
        let alert = UIAlertController(title: "Add client", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "First name" }
        alert.addTextField { (tf) in tf.placeholder = "Last name" }
        
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let firstName = alert.textFields?[0].text,
                let lastName = alert.textFields?[1].text
                else {return}
            let params = ["firstName": firstName,
                          "lastName": lastName] as [String : Any]
//            HTTPClient.shared.postClient(
//                params: params,
//                onSuccess: { client in
//                    DispatchQueue.main.async {
//                        self.clients.append(client)
//                        self.tableView.reloadData()
//                    }
//            }, onFailure: { error in
//                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//                self.show(alert, sender: nil)
//            })
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion:  nil)

    }
    var lesson: Lesson!
    var date: Date!
    var coach: Coach!
    var clients: [IClient]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.title = lesson!.title
        dateLabel.text = stringFromDate(date)
        categoryLabel.text = lesson!.category
        coachLabel.text = coach.fullName
        freePlacesCntLabel.text = String(lesson!.maxPeopleCnt)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ScheduleDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return clients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientItem", for: indexPath)
        
//        let client = clients[indexPath.row]
//        print(client.firstName + " " + client.lastName)
//        cell.textLabel?.text = client.firstName + " " + client.lastName
        
        return cell
    }
}

