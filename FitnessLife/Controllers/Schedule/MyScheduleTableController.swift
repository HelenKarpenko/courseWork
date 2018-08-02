//
//  MyScheduleTableController.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 5/2/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit
import RealmSwift

class MyScheduleTableController: UITableViewController, UISearchBarDelegate {

    
    
    
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        //        return true
//        return User.currUser is Coach
//    }
    
    var schedule: List<ScheduleItem>?
    var filteredSchedule: List<ScheduleItem>?
    @IBOutlet weak var searchBar: UISearchBar!
    var restored = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        schedule = User.currUser?.schedule
        filteredSchedule = schedule
        
//        StateManager.shared.mainTabIndex = tabBarController.selectedIndex
//
//        if !restored {
//            StateManager.shared.restore(viewController: self as Restorable)
//            restored = true
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSchedule!.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleItem", for: indexPath)
        
        let lesson = filteredSchedule![indexPath.row]
        cell.textLabel?.text = lesson.lesson?.title
        cell.detailTextLabel?.text = stringFromDate(lesson.date)
        cell.imageView?.image = lesson.lesson?.icon
        
        return cell
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        //        guard !searchText.isEmpty else {
//        //            filteredSchedule = schedule
//        //            scheduleTable.reloadData()
//        //            return
//        //        }
//        //        filteredSchedule = schedule.filter({ scheduleItem -> Bool in
//        //            guard let text = searchBar.text, let lesson = scheduleItem.lesson else {
//        //                return false
//        //            }
//        //            return lesson.title.contains(text)
//        //        })
//        //        scheduleTable.reloadData()
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        if selectedScope == 0 {
//            filteredSchedule = User.currUser?.schedule
//        } else {
//            filteredSchedule = User.currUser?.schedule.filter({ item -> Bool in
//                dayOfWeekFromDate(item.date) == selectedScope + 1
//            })
//        }
//        scheduleTable.reloadData()
//    }

//    // MARK: - Search
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        let byTitle = NSPredicate(format: "lesson.title CONTAINS[c] %@", searchText)
//
//        switch searchBar.selectedScopeButtonIndex {
//        case 0:
//            if searchText.isEmpty {
//                filteredSchedule = db.schedule
//            } else {
//                filteredSchedule = db.schedule.filter(byTitle)
//            }
//        case 1:
//            let byWeekDay = NSPredicate(format: "day = 2")
//            filterSchedule(withSearchText: searchText, byTitle: byTitle, byWeekDay: byWeekDay)
//        case 2:
//            let byWeekDay = NSPredicate(format: "day = 3")
//            filterSchedule(withSearchText: searchText, byTitle: byTitle, byWeekDay: byWeekDay)
//        case 3:
//            let byWeekDay = NSPredicate(format: "day = 4")
//            filterSchedule(withSearchText: searchText, byTitle: byTitle, byWeekDay: byWeekDay)
//        case 4:
//            let byWeekDay = NSPredicate(format: "day = 5")
//            filterSchedule(withSearchText: searchText, byTitle: byTitle, byWeekDay: byWeekDay)
//        case 5:
//            let byWeekDay = NSPredicate(format: "day = 6")
//            filterSchedule(withSearchText: searchText, byTitle: byTitle, byWeekDay: byWeekDay)
//        default:
//            filteredSchedule = db.schedule
//        }
//        tableView.reloadData()
//    }
//
//    private func filterSchedule(withSearchText searchText: String, byTitle: NSPredicate, byWeekDay: NSPredicate){
//        if searchText.isEmpty {
//            filteredSchedule = db.schedule.filter(byWeekDay)
//        } else {
//            let filter = NSCompoundPredicate(andPredicateWithSubpredicates: [byWeekDay, byTitle])
//            filteredSchedule = db.schedule.filter(filter)
//        }
//    }
//
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScheduleItemDetail" {
            guard let controller = segue.destination as? ScheduleItemDetailController else {
                fatalError("Cannot find ScheduleItemDetailController")
            }
            if let row = tableView.indexPathForSelectedRow?.row {
                controller.scheduleItem = filteredSchedule![row]
            }
        }
    }

}

//// MARK: - Memento
//
//private enum StateKeys: String {
//    case textFieldState
//    case switchState
//    case segmentedState
//
//}
//
//extension MyScheduleTableController: Restorable {
//    var state: State {
//        return [:]
//    }
//
//    func restore(from state: State) -> Bool {
//        let result = true
//        return result
//    }
//}

