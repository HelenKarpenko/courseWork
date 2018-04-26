//
//  EditorTextCell.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/24/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit


class EditorTextCell: UITableViewCell {
    
    @IBOutlet weak private var propertyTitle: UILabel!
    @IBOutlet weak private var propertyValue: UITextField!
    
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
        propertyValue.delegate = self
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension EditorTextCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        value = textField.text
        if let onComplete = onComplete {
            onComplete(value)
        }
    }
}
