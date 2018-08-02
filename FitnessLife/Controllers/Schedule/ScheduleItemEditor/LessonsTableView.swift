//
//  LessonsTableView.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/29/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

class LessonsTableView: UITableViewController {

    let lessons = DataBase.shared.lessons
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonItem", for: indexPath)

        let lesson = lessons![indexPath.row]
        cell.textLabel?.text = lesson.title + " (" + String(lesson.maxPeopleCnt) + ")"
        cell.detailTextLabel?.text = lesson.category

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContinuedCreation" {
            guard let controller = segue.destination as? ScheduleItemEditorController else {
                fatalError("Cannot find ScheduleItemEditorController")
            }
            if let row = tableView.indexPathForSelectedRow?.row {
                let scheduleItem = ScheduleItem()
                scheduleItem.id = ScheduleItem.getId()
                scheduleItem.lesson = lessons![row]
                controller.scheduleItem = scheduleItem
            }
        }
    }

}
