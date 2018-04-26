//
//  CoachTableView.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/21/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit
import RealmSwift

class CoachTableView: UITableViewController, UISearchBarDelegate {

    var notificationToken: NotificationToken!
    
    var filteredCoaches: Results<Coach>?
    var db = DataBase.shared
    
    @IBOutlet weak var searchBar: UISearchBar!

    func configure() {
        notificationToken =
            db.coaches.observe({ [weak self] change in
                switch change  {
                case .initial(_):
                    self?.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self?.tableView.applyChanges(deletions: deletions, insertions: insertions, updates: modifications)
                case .error(let e):
                    print("Synchronization error: \(e)")
                }
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
        filteredCoaches = db.coaches
        tableView.reloadData()
        searchBar.delegate = self
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    @IBAction func addCoachButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Create new coach", message: "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let fullName = alertController.textFields![0].text
            let phone = alertController.textFields![1].text
            let email = alertController.textFields![2].text
            let address = alertController.textFields![3].text

            if fullName != "", phone != "", email != "", address != "" {
                let coach = Coach()
                coach.id = Coach.getId()
                coach.fullName = fullName!
                coach.phone = phone!
                coach.email = email!
                coach.address = address!
                do {
                    try self.db.addNewCoach(coach)
                } catch {
                    fatalError("vse ploho!")
                }
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Please input both a first AND last name", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                    alert -> Void in
                    self.present(alertController, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Full Name"
            textField.textAlignment = .center
        })
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Phone"
            textField.textAlignment = .center
        })
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Email"
            textField.textAlignment = .center
        })
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Address"
            textField.textAlignment = .center
        })
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCoaches!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerItem", for: indexPath)
        
        let coach = filteredCoaches![indexPath.row]
        cell.textLabel?.text = coach.fullName
        cell.detailTextLabel?.text = coach.category
        
        return cell
    }
    
    // MARK: - Remove
    
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
     }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "Remove", message: "Are you sure?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ -> Void in
                let coach = self.filteredCoaches![indexPath.row]
                do {
                    try self.db.removeCoach(coach)
                } catch {
                    fatalError("vse ploho!")
                }
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ -> Void in }))
            self.present(alertController, animated: true, completion: nil)
            
            
        } else if editingStyle == .insert {
            print("error")
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        let itemToMove = filteredCoaches![fromIndexPath.row]
//        filteredCoaches.remove(at: fromIndexPath.row)
//        filteredCoaches.insert(itemToMove, at: fromIndexPath.row)
//    }
    
    // MARK: - Search

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let byFullName = NSPredicate(format: "fullName CONTAINS[c] %@", searchText)
        
        switch searchBar.selectedScopeButtonIndex {
        case 0:
            if searchText.isEmpty {
                filteredCoaches = db.coaches
            } else {
                filteredCoaches = db.coaches.filter(byFullName)
            }
        case 1:
            let byCategory = NSPredicate(format: "category = 'Yoga'")
            filterCoaches(withSearchText: searchText, byFullName: byFullName, byCategory: byCategory)
        case 2:
            let byCategory = NSPredicate(format: "category ='Swimming'")
            filterCoaches(withSearchText: searchText, byFullName: byFullName, byCategory: byCategory)
        case 3:
            let byCategory = NSPredicate(format: "category ='Gymnastics'")
            filterCoaches(withSearchText: searchText, byFullName: byFullName, byCategory: byCategory)
        default:
            filteredCoaches = db.coaches
        }
        tableView.reloadData()
    }
    
    private func filterCoaches(withSearchText searchText: String, byFullName: NSPredicate, byCategory: NSPredicate){
        if searchText.isEmpty {
            filteredCoaches = db.coaches.filter(byCategory)
        } else {
            let filter = NSCompoundPredicate(andPredicateWithSubpredicates: [byCategory, byFullName])
            filteredCoaches = db.coaches.filter(filter)
        }
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {

        switch searchBar.selectedScopeButtonIndex {
        case 0:
            filteredCoaches = db.coaches
        case 1:
            let byCategory = NSPredicate(format: "category = 'Yoga'")
            filteredCoaches = db.coaches.filter(byCategory)
        case 2:
            let byCategory = NSPredicate(format: "category ='Swimming'")
            filteredCoaches = db.coaches.filter(byCategory)
        case 3:
            let byCategory = NSPredicate(format: "category ='Gymnastics'")
            filteredCoaches = db.coaches.filter(byCategory)
        default:
            filteredCoaches = db.coaches
        }
        tableView.reloadData()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "TrainerDetail" {
        //            guard let controller = segue.destination as? CoachDetailController else {
        //                fatalError("Cannot find TrainerDetailController")
        //            }
        //            if let row = tableView.indexPathForSelectedRow?.row {
        //                controller.coach = currentCoaches[row]
        //
        //            }
        //        }
    }
    
}
