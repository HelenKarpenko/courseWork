//
//  CalculateBillCell.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 5/2/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

protocol CalculateBillHandler {
    func calculateBill()
}

class CalculateBillCell: UITableViewCell {

    
//    var schedule: ScheduleItem!
    var delegate: CalculateBillHandler?
//
//    @IBAction func Enroll(_ sender: Any) {
//
//        let user = User.currUser
//        do {
//            try DataBase.shared.addClientToGroup(schedule: schedule, client: user as! Client)
//        } catch {
//            delegate?.onEnrollError(error)
//        }
//
//    }
    
    @IBAction func calculateBill(_ sender: Any) {
        delegate?.calculateBill()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
