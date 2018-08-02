//
//  DatePickerCell.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/29/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

class DatePickerCell: UITableViewCell {
    
   
    @IBOutlet weak var propertyTitle: UILabel!
    @IBOutlet weak var propertyValue: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
        let strDate = dateFormatter.string(from: datePicker.date)
        value = strDate
        if let onComplete = onComplete {
            onComplete(value)
        }
    }
    
    var key: String? {
        didSet {
            propertyTitle.text = key
        }
    }
    var value: String? {
        didSet {
            propertyValue.text = value
        }
    }
    
    // change callback which will write value back
    var onComplete:((String?)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}


