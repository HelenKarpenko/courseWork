//
//  TrainerList.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/16/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit


class TrainerList: UITableViewController {
    
    var coaches = [Coach]()
    
    @IBAction func addCoachButton(_ sender: UIButton) {
        print("INSERT coach")
        let alert = UIAlertController(title: "Add coach", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "First name" }
        alert.addTextField { (tf) in tf.placeholder = "Last name" }
        alert.addTextField { (tf) in tf.placeholder = "Category" }
        alert.addTextField { (tf) in tf.placeholder = "Experience" }
        alert.addTextField { (tf) in tf.placeholder = "Position" }
        
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let firstName = alert.textFields?[0].text,
                let lastName = alert.textFields?[1].text,
                let category = alert.textFields?[2].text,
                let experience = alert.textFields?[3].text,
                let position = alert.textFields?[4].text
                else {return}
            let params = ["firstName": firstName,
                          "lastName": lastName,
                          "category": category,
                          "experience": Int(experience) ?? 0,
                          "position": position] as [String : Any]
            APIManager.sharedInstance.postCoach(
                params: params,
                onSuccess: { coach in 
                    DispatchQueue.main.async {
                        self.coaches.append(coach)
                        self.tableView.reloadData()
                    }
            }, onFailure: { error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.show(alert, sender: nil)
            })
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion:  nil)
    }
    
    func populateTrainers() {

        APIManager.sharedInstance.getAllCoaches(
            onSuccess: { coaches in
            DispatchQueue.main.async {
                self.coaches = coaches
                self.tableView.reloadData()
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateTrainers();
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return coaches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerItem", for: indexPath)

        // Configure the cell...
        let trainer = coaches[indexPath.row]
        cell.textLabel?.text = trainer.firstName + " " + trainer.lastName
        cell.detailTextLabel?.text = String(describing: trainer.category)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {        
        if editingStyle == .delete {
            print("delete")
            APIManager.sharedInstance.deleteCoach(
                id: coaches[indexPath.row].id,
                onSuccess: { coach in
                    DispatchQueue.main.async {
                        self.coaches.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .right)
                    }
            }, onFailure: { error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.show(alert, sender: nil)
            })
            
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            print("error")
        }    
    }


    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let itemToMove = coaches[fromIndexPath.row]
        coaches.remove(at: fromIndexPath.row)
        coaches.insert(itemToMove, at: fromIndexPath.row)
    }


    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "TrainerDetail" {
            guard let controller = segue.destination as? TrainerDetailController else {
                fatalError("Cannot find TrainerDetailController")
            }
            if let row = tableView.indexPathForSelectedRow?.row {
                controller.coach = coaches[row]
                
            }
        }
    }

}
