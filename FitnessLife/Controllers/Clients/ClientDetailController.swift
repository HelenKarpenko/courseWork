//
//  ClientDetailController.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/23/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit


fileprivate enum CellType: Int {
    case phone
    case email
    case address
    case schedule
    case button
    
    var text: String {
        switch self {
        case .phone: return "Phone"
        case .email: return "Email"
        case .address: return "Address"
        case .schedule: return "Schedule"
        case .button: return "CalculateBill"
        }
    }
}

class ClientDetailController: UIViewController {
    var clientToShow: Client?
    var client: IUser { return clientToShow ?? User.currUser!}
    var fields = [String]()
    var values = [String]()
    
    @IBOutlet weak var clientFullName: UILabel!
    @IBOutlet weak var clientDataTable: UITableView!
    
    private func setupData() {
        self.clientFullName.text = client.fullName
        
        self.fields = [CellType.phone.text,
                       CellType.email.text,
                       CellType.address.text,
                       CellType.schedule.text,
                       CellType.button.text]
        
        self.values = [client.phone,
                       client.email,
                       client.address,
                       "Details"]
    }
    
    private func setupView() {
        self.clientDataTable.dataSource = self
        self.clientDataTable.delegate = self
        self.clientDataTable.tableFooterView = UIView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }
    
    @IBAction func signOut(_ sender: Any) {
        User.currUser = nil
        performSegue(withIdentifier: "SignOut", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenCoachSchedule" {
            guard let controller = segue.destination as? CoachSheduleTableView else {
                fatalError("Cannot find CoachScheduleTableView")
            }
            controller.user = client
        }
        
        if segue.identifier == "SignOut" {
            guard let _ = segue.destination as? LogIn else {
                fatalError("Cannot find LogIn")
            }
        }
    }

}

extension ClientDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case CellType.button.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalculateBillItem", for: indexPath) as? CalculateBillCell else {
                fatalError("Vse ploho")
            }
            cell.delegate = self
            return cell
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoachDataItem", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel!.text = fields[indexPath.row]
            cell.detailTextLabel!.text = values[indexPath.row]
            if fields[indexPath.row] == "Schedule" {
                cell.detailTextLabel?.textColor = .blue
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                cell.selectionStyle = .default
            }
            return cell
        }
    }
}

extension ClientDetailController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fields.index(of: "Schedule") == indexPath.row {
            performSegue(withIdentifier: "OpenCoachSchedule", sender: nil)
        }
    }
}

extension ClientDetailController: CalculateBillHandler {
    
    func calculateBill() {
        let bill = User.currUser?.getPayment()
        let info = "Your bill is \(String(describing: bill!))₴"
        displayAlertMessage(info)
    }
    
    func displayAlertMessage(_ userMessage:String){
    
        let alert = UIAlertController(title:"Bill", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil)
        alert.addAction(ok)
        self.present(alert, animated:true, completion:nil)
        
    }
    
}


