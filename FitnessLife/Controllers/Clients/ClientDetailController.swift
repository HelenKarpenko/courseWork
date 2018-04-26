//
//  ClientDetailController.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/23/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

class ClientDetailController: UIViewController {

    var client: IClient!
//    var clientData: [ClientData]!
    
    @IBOutlet weak var clientFullName: UILabel!
    @IBOutlet weak var clientDataTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.clientData = self.client.tableRepresentation
        self.clientDataTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        clientFullName.text = clientData[0].value
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

extension ClientDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
//        return clientData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientDataItem", for: indexPath)
//        cell.textLabel!.text = clientData[indexPath.row].title
//        cell.detailTextLabel!.text = clientData[indexPath.row].value
//        if clientData[indexPath.row].title == "Schedule" {
//            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
//        }
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if self.clientDataTable.indexPathForSelectedRow?.row == (clientData.count - 1) {
//            if segue.identifier == "ClientSchedule" {
//                guard let controller = segue.destination as? ClientScheduleTableView else {
//                    fatalError("Cannot find ClientScheduleTableView")
//                }
//                controller.schedule = client.schedule
//            }
//        }
    }
}
