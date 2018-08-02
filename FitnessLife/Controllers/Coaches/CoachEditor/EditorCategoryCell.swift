//
//  EditorCategoryCell.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 5/2/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

class EditorCategoryCell: UITableViewCell {

    @IBOutlet weak var propertyTitle: UILabel!
    @IBOutlet weak var propertyValue: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    //var pickerData: [String] = [String]()
    var pickerData: [String] = ["First", "Second", "Third"]
    
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
    
    private func setupView() {
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension EditorCategoryCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
}

extension EditorCategoryCell: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onComplete?(pickerData[row])
    }
}

