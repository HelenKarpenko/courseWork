//
//  TrainerDetailController.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/16/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

class CoachDetailController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scheduleTable: UITableView!
    @IBOutlet weak var CategoryLabel: UILabel!
    @IBOutlet weak var experianceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var coach: Coach!
    var schedule = [ScheduleItem]()
    var filteredSchedule = [ScheduleItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.schedule = coach.schedule
        self.filteredSchedule = self.schedule
        
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        CategoryLabel.text = coach.category
        experianceLabel.text = String(describing: coach.experience)
        nameLabel.text = coach.fullName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CoachDetailController: UITableViewDataSource, UISearchBarDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSchedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonItem", for: indexPath)
//
//        let lesson = filteredSchedule[indexPath.row].lesson
//        let date = filteredSchedule[indexPath.row].date
//        cell.textLabel?.text = lesson?.title
//        cell.detailTextLabel?.text = stringFromDate(date)
//
        return cell
    }
    
    // MARK: - Search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        guard !searchText.isEmpty else {
//            filteredSchedule = schedule
//            scheduleTable.reloadData()
//            return
//        }
//        filteredSchedule = schedule.filter({ scheduleItem -> Bool in
//            guard let text = searchBar.text, let lesson = scheduleItem.lesson else {
//                return false
//            }
//            return lesson.title.contains(text)
//        })
//        scheduleTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0 {
            filteredSchedule = schedule
        } else {
//            filteredSchedule = schedule.filter({ item -> Bool in
//                dayOfWeekFromDate(item.date) == selectedScope + 1
//            })
        }
        scheduleTable.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "LessonDetail" {
//            guard let controller = segue.destination as? ScheduleDetailController else {
//                fatalError("Cannot find ScheduleDetailController")
//            }
//            guard let row = scheduleTable.indexPathForSelectedRow?.row else  {
//                fatalError("Cannot define Lesson")
//            }
//            let scheduleItem = filteredSchedule[row]
//            let lesson = scheduleItem.lesson!
//            let clients = scheduleItem.clients!
//            controller.lesson = lesson
//            controller.date = scheduleItem.date
//            controller.coach = coach
//            controller.clients = clients
//        }
    }
}

