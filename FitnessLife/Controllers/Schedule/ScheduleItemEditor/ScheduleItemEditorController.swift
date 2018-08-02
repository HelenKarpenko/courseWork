//
//  ScheduleItemEditorController.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/28/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

fileprivate enum CellType: Int {
    case title
    case category
    case peopleCount
    case duration
    case price
    case coach
    case date
    
    var text: String {
        switch self {
        case .title: return "Title"
        case .category: return "Category"
        case .peopleCount: return "People count"
        case .duration: return "Duration"
        case .price: return "Price"
        case .coach: return "Coach"
        case .date: return "Date"
        }
    }
}

class ScheduleItemEditorController: UITableViewController {

    var scheduleItem: ScheduleItem!
    
    var fields = [String]()
    var values = [String]()
    
    private var dateCellExpanded: Bool = false
    
    private func setupData() {
        self.fields = [CellType.title.text,
                       CellType.category.text,
                       CellType.peopleCount.text,
                       CellType.duration.text,
                       CellType.price.text,
                       CellType.coach.text,
                       CellType.date.text]
        self.values = [scheduleItem.lesson!.title,
                       scheduleItem.lesson!.category,
                       String(scheduleItem.lesson!.maxPeopleCnt),
                       String(scheduleItem.lesson!.duration),
                       String(scheduleItem.lesson!.price),
                       scheduleItem.coach?.fullName ?? "Select",
                       stringFromDate(scheduleItem.date)]
    }
    
    private func setupView() {
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }
    
    @IBAction func save(_ sender: UIButton) {
        do {
            try DataBase.shared.addNewScheduleItem(scheduleItem)
            self.dismiss(animated: true, completion: nil)
        } catch {
            fatalError("vse ploho!")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.row {
        case CellType.date.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as? DatePickerCell else {
                fatalError("Vse ploho")
                
            }
            cell.key = fields[indexPath.row]
            cell.value = values[indexPath.row]
            cell.propertyValue.textColor = .blue

            cell.onComplete = { [weak self] value in
                self?.scheduleItem.date = dateFromString(value!)
                self?.scheduleItem.setWeekDay()
                self?.values[indexPath.row] = value ?? ""
            }
            return cell
        case CellType.coach.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
            
            cell.textLabel?.text = fields[indexPath.row]
            cell.detailTextLabel?.text = values[indexPath.row]
            
            cell.detailTextLabel?.textColor = .blue
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
            
            cell.textLabel?.text = fields[indexPath.row]
            cell.detailTextLabel?.text = values[indexPath.row]
           
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fields.index(of: "Date") == indexPath.row {
            dateCellExpanded = !dateCellExpanded
        }
        tableView.beginUpdates()
        tableView.endUpdates()

        if fields.index(of: "Coach") == indexPath.row {
            performSegue(withIdentifier: "OpenCoachesTable", sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if fields.index(of: "Date") == indexPath.row {
            if dateCellExpanded{
                return 250
            }else{
                return 50
            }
        }
        return 50
    }
    
   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenCoachesTable" {
            guard let nav = segue.destination as? UINavigationController,
                let controller = nav.topViewController as? CoachSelectionTableView
            else {
                fatalError("Cannot find CoachSelectionTableView")
            }
            let byCategory = NSPredicate(format: "category = '\(String(describing: self.scheduleItem.lesson!.category))'")
            controller.coaches = DataBase.shared.coaches.filter(byCategory)
            controller.onSelect = { [weak self] coach in
                let ip = IndexPath(row: CellType.coach.rawValue, section: 0)
                self?.scheduleItem.coach = coach
                self?.values[ip.row] = coach?.fullName ?? ""
                self?.tableView.reloadRows(at: [ip], with: .automatic)
            }
        }
    }
     

}
