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
    @IBOutlet weak var addButton: UIButton!
    var filteredCoaches: Results<Coach>?
    var db = DataBase.shared
    var restored = false
    
    @IBOutlet weak var searchBar: UISearchBar!

    private func subscribeOnChanges() {
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
    
    private func setupData() {
        self.subscribeOnChanges()
        filteredCoaches = db.coaches
        tableView.reloadData()
    }
    
    private func setupRole() {
        if User.currUser is Client {
            self.addButton.isHidden = true
        }
    }
    
    private func setupView() {
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    private func restoreState() {
        guard let tabBarController = self.parent?.parent as? UITabBarController else {
            return
        }
        StateManager.shared.mainTabIndex = tabBarController.selectedIndex
        if !restored {
            StateManager.shared.restore(viewController: self as Restorable)
            restored = true
        }
    }
    
    private func saveState() {
        StateManager.shared.store(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupRole()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        restoreState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saveState()
    }
    
    @IBAction func addCoachButton(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let editor = sb.instantiateViewController(withIdentifier: "CoachEditor") as? CoachEditorController else {
            fatalError("vse ploho!")
        }
        
        let nav = UINavigationController(rootViewController: editor)
        self.present(nav, animated: true, completion: nil)
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
        cell.imageView?.image = coach.rank.icon
        
        return cell
    }
    
    // MARK: - Remove
    
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return User.currUser is Coach
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

    
    // MARK: - Search
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        search()
        searchBar.resignFirstResponder()
    }
    
    func search() {
        let searchText = searchBar.text ?? ""
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
        case 4:
            let byCategory = NSPredicate(format: "category ='Dance'")
            filterCoaches(withSearchText: searchText, byFullName: byFullName, byCategory: byCategory)
        case 5:
            let byCategory = NSPredicate(format: "category ='Box'")
            filterCoaches(withSearchText: searchText, byFullName: byFullName, byCategory: byCategory)
        default:
            filteredCoaches = db.coaches
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search()
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
        search()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CoachDetail" {
            guard let controller = segue.destination as? CoachDetailController else {
                fatalError("Cannot find CoachDetailController")
            }
            if let row = tableView.indexPathForSelectedRow?.row {
                controller.coach = filteredCoaches![row]
            }
        }
    }
    
}

// MARK: - Memento

private enum StateKeys: String {
    case searchState
    case searchTabState
}


extension CoachTableView: Restorable {
    var state: State {
        return [StateKeys.searchState.rawValue: self.searchBar.text ?? "",
                StateKeys.searchTabState.rawValue: self.searchBar.selectedScopeButtonIndex]
    }
    
    func restore(from state: State) -> Bool {
        var result = true
        
        self.searchBar.text = state[StateKeys.searchState.rawValue] as? String ?? ""
        var searchTabIndex = state[StateKeys.searchTabState.rawValue] as? Int ?? 0
        if (searchTabIndex < 0 || searchTabIndex > 5) {
            result = false
            searchTabIndex = 0
        }
        self.searchBar.selectedScopeButtonIndex = searchTabIndex
        search()
        
        return result
    }
}

