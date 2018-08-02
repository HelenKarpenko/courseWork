//
//  EnrollButtonCell.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 5/1/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

protocol EnrollHandler {
    func onEnrollError(_ error: Error)
    func onEnrollSuccess()
}

class EnrollButtonCell: UITableViewCell {

    var schedule: ScheduleItem!
    var delegate: EnrollHandler?
    @IBOutlet weak var enrollButton: UIButton!
    
    @IBAction func Enroll(_ sender: Any) {
        let user = User.currUser
        do {
            try DataBase.shared.addClientToGroup(schedule: schedule, client: user as! Client)
            delegate?.onEnrollSuccess()
        } catch {
            delegate?.onEnrollError(error)
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}



