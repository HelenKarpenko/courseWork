//
//  CoachEditorController.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/26/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

fileprivate enum CellType: Int {
    case fullName
    case category
    case expirience
    case phone
    case email
    case address
    case password
    
    var text: String {
        switch self {
        case .fullName: return "Full name"
        case .category: return "Category"
        case .expirience: return "Expirience"
        case .phone: return "Phone"
        case .email: return "Email"
        case .address: return "Address"
        case .password: return "Password"
        }
    }
}

class CoachEditorController: UITableViewController  {

    var coach: Coach?
    
    var fields = [String]()
    var values = [String]()
    
    private var dateCellExpanded: Bool = false
    
    private func setupData() {
        self.fields = [CellType.fullName.text,
                       CellType.category.text,
                       CellType.expirience.text,
                       CellType.phone.text,
                       CellType.email.text,
                       CellType.address.text,
                       CellType.password.text]
        self.values = ["", "", "", "", "", "", ""]
    }
    
    private func setupView() {
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        let creator = CoachCreator()
        self.coach = creator.createUser(withFullName: values[0],
                                        withPhone: values[3],
                                        withEmail: values[4],
                                        withAddress: values[5],
                                        withPassword: values[6]) as? Coach
        self.coach?.category = values[1]
        self.coach?.experience = Int(values[2]) ?? 0
        
        do {
            try DataBase.shared.addNewCoach(coach!)
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditorTextCell", for: indexPath) as? EditorTextCell else {
            fatalError("Vse ploho")
        }
        cell.key = fields[indexPath.row]
        cell.value = values[indexPath.row]
        cell.onComplete = { [weak self] value in
            self?.values[indexPath.row] = value ?? ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if CellType.category.rawValue == indexPath.row {
            if dateCellExpanded{
                return 220
            }else{
                return 50
            }
        }
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fields.index(of: "Category") == indexPath.row {
            dateCellExpanded = !dateCellExpanded
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
