//
//  ScheduleList.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/16/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit


class ScheduleList: UITableViewController {
    
    var schedule = [ScheduleItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateData()
        tableView.reloadData()
        
        let urlString = "http://localhost:3004/coaches"
        let requestUrl = URL(string:urlString)
        if requestUrl == nil {
            print("ERROR")
        }else{
            let request = URLRequest(url:requestUrl!)
            let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                if error == nil,let usableData = data {
                    print(usableData) //JSONSerialization
                }
            }
            task.resume()
        }
    }
    
    func populateData() {
//        let coach = Coach(.athletics, "Elena", "Karpenko", 18)
//        
//        schedule = [
//            Lesson(.swimming, "First Event", [.day: 2, .month: 3, .year: 2018, .hour: 18, .minute: 30], coach, 10),
//            Lesson(.boxing, "Second Event", [.day: 3, .month: 4, .year: 2018, .hour: 18, .minute: 30], coach, 20),
//            Lesson(.swimming, "Third Event", [.day: 4, .month: 5, .year: 2018, .hour: 18, .minute: 30], coach,30)
//        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SceduleItem", for: indexPath)

//        // Configure the cell...
//        if let lesson = schedule[indexPath.row].lesson {
//            cell.textLabel?.text = lesson.title
//            // cell.detailTextLabel?.text = String(describing: lesson.date)
//        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "ScheduleDetail" {
//            guard let controller = segue.destination as? ScheduleDetailController else {
//                fatalError("Cannot find ScheduleDetailController")
//            }
//            if let row = tableView.indexPathForSelectedRow?.row {
//                controller.lesson = currentSchedule[row]
//                
//            }
//        }
//    }
    

}
