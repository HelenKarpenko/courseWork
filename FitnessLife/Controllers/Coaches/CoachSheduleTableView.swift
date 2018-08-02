//
//  CoachSheduleTableView.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/28/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit
import RealmSwift

class CoachSheduleTableView: UITableViewController, UISearchBarDelegate {

    var notificationToken: NotificationToken!
    
//    var coach: Coach!
    var user: IUser!
    var filteredSchedule: List<ScheduleItem>?
    var db = DataBase.shared
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func subscribeOnChanges() {
        notificationToken =
            db.coaches.observe({ [weak self] change in
                switch change  {
                case .initial(_):
                    self?.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self?.tableView.applyChanges(deletions: deletions, insertions: insertions, updates: modifications)
                case .error(let e):
                    print("Synchronization error: \(e)")
                }
            })
    }
    
    private func setupData() {
        self.subscribeOnChanges()
    }
    
    private func setupView() {
        searchBar.delegate = self
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.schedule.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleItem", for: indexPath)
        
        let scheduleItem = user.schedule[indexPath.row]
        cell.textLabel?.text = scheduleItem.lesson?.title
        cell.detailTextLabel?.text = stringFromDate(scheduleItem.date)
    
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScheduleItemDetail" {
            guard let controller = segue.destination as? ScheduleItemDetailController else {
                fatalError("Cannot find ScheduleItemDetailController")
            }
            if let row = tableView.indexPathForSelectedRow?.row {
                controller.scheduleItem = user.schedule[row]
            }
        }
    }

}

