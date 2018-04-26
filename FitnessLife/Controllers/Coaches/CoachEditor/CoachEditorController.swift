//
//  CoachEditorController.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/26/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

class CoachEditorController: UITableViewController {

    var client: IClient?
    var creator: ICreator?
    var clientData = [ClientData]()
    
    var fields = [String]()
    var values = [String]()
    
    func populateData() {
        switch self.creator {
        case is PrivateClientCreator:
            self.fields = ["Full name", "Phone", "Email", "Address"]
            self.values = ["", "", "", ""]
        case is CorporateClientCreator:
            self.fields = ["Full name", "Company phone", "Company email", "Company address", "Company name"]
            self.values = ["", "", "", "", ""]
        default: break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        // TODO: - FactoryMethod
        switch self.creator {
        case is PrivateClientCreator:
            self.client = creator?.createClient(withFullName: values[0],
                                                withPhone: values[1],
                                                withEmail: values[2],
                                                withAddress: values[3],
                                                withCompanyName: nil)
        case is CorporateClientCreator:
            self.client = creator?.createClient(withFullName: values[0],
                                                withPhone: values[1],
                                                withEmail: values[2],
                                                withAddress: values[3],
                                                withCompanyName: values[4])
        default: break
        }
        
        do {
            try DataBase.shared.addNewClient(client!)
            self.dismiss(animated: true, completion: nil)
        } catch {
            fatalError("vse ploho!")
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        //cell.tag = indexPath.row
        cell.key = fields[indexPath.row]
        cell.value = values[indexPath.row]
        cell.onComplete = { [weak self] value in
            self?.values[indexPath.row] = value ?? ""
        }
        return cell
    }

}
