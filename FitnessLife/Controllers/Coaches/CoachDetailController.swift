//
//  CoachDetailController.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/28/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

class CoachDetailController: UIViewController {

    var coach: Coach!
    var fields = [String]()
    var value = [String]()
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var coachInfoTable: UITableView!
    
    private func setupData() {
        self.fullName.text = coach.fullName
        self.fields = ["Category", "Expirience", "Phone", "Email", "Address", "Schedule"]
        self.value = [coach.category,
                      String(coach.experience),
                      coach.phone,
                      coach.email,
                      coach.address,
                      "details"]
    }
    
    private func setupView() {
        self.coachInfoTable.dataSource = self
        self.coachInfoTable.delegate = self
        self.coachInfoTable.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenCoachSchedule" {
            guard let controller = segue.destination as? CoachSheduleTableView else {
                fatalError("Cannot find CoachScheduleTableView")
            }
            controller.user = coach
        }
    }
}

extension CoachDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoachDataItem", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel!.text = fields[indexPath.row]
        cell.detailTextLabel!.text = value[indexPath.row]
            if fields[indexPath.row] == "Schedule" {
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                cell.selectionStyle = .default
            }
        return cell
    }
}

extension CoachDetailController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fields.index(of: "Schedule") == indexPath.row {
            performSegue(withIdentifier: "OpenCoachSchedule", sender: nil)
        }
    }
}
