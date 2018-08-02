//
//  ScheduleItemDetailController.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 5/1/18.
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
    case button
    
    var text: String {
        switch self {
        case .title: return "Title"
        case .category: return "Category"
        case .peopleCount: return "People count"
        case .duration: return "Duration"
        case .price: return "Price"
        case .coach: return "Coach"
        case .date: return "Date"
        case .button: return "Enroll"
        }
    }
}

class ScheduleItemDetailController: UIViewController {

    var scheduleItem: ScheduleItem!
    
    var fields = [String]()
    var values = [String]()
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tableDetail: UITableView!
    @IBOutlet weak var titleField: UILabel!
    
    private func setupData() {
        self.titleField.text = scheduleItem.lesson?.title
        self.image.image = scheduleItem.lesson?.icon
        
        self.fields = [CellType.title.text,
                       CellType.category.text,
                       CellType.peopleCount.text,
                       CellType.duration.text,
                       CellType.price.text,
                       CellType.coach.text,
                       CellType.date.text,
                       CellType.button.text]
        
        self.values = [scheduleItem.lesson!.title,
                       scheduleItem.lesson!.category,
                       String(scheduleItem.lesson!.maxPeopleCnt),
                       String(scheduleItem.lesson!.duration),
                       String(scheduleItem.lesson!.price),
                       scheduleItem.coach?.fullName ?? "Select",
                       stringFromDate(scheduleItem.date)]
    }
    
    private func setupView() {
        self.tableDetail.dataSource = self
        tableDetail.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }
}

extension ScheduleItemDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case CellType.button.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonItem", for: indexPath) as? EnrollButtonCell else {
                fatalError("Vse ploho")
            }
            cell.schedule = scheduleItem
            cell.delegate = self
            cell.isHidden = User.currUser is Coach || (User.currUser?.schedule.contains(scheduleItem))!
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataItem", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel!.text = fields[indexPath.row]
            cell.detailTextLabel!.text = values[indexPath.row]
            return cell
        }
    }
}

extension ScheduleItemDetailController: EnrollHandler {
    func onEnrollError(_ error: Error) {
        var message = error.localizedDescription
        if let ce = error as? ClientError {
            message = ce.localizedDescription
        }
        displayAlertMessage("Error", message)
    }
    
    func onEnrollSuccess() {
        let message = "You have successfully enroll for a lesson \(scheduleItem.lesson!.title)"
        let indexPath = IndexPath(row: CellType.button.rawValue, section: 0)
        let cell = tableDetail.cellForRow(at: indexPath)
        cell?.isHidden = (User.currUser?.schedule.contains(scheduleItem))!
        displayAlertMessage("Success", message)
    }
    
    func displayAlertMessage(_ title: String, _ userMessage:String){
        
        let alert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil)
        alert.addAction(ok)
        self.present(alert, animated:true, completion:nil)
        
    }

}
