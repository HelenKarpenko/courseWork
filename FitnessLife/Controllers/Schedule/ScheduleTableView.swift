//
//  SceduleTableView.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/28/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit
import RealmSwift

class ScheduleTableView: UITableViewController, UISearchBarDelegate {
    
    var notificationToken: NotificationToken!
    
    var filteredSchedule: Results<ScheduleItem>?
    var db = DataBase.shared
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var restored = false
    
    func subscribeOnChanges() {
        notificationToken =
            db.schedule.observe({ [weak self] change in
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
        filteredSchedule = db.schedule
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
    
    @IBAction func addLesson(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let editor = sb.instantiateViewController(withIdentifier: "LessonsSelection") as? LessonsTableView else {
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
        return filteredSchedule!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleItem", for: indexPath)
        
        let lesson = filteredSchedule![indexPath.row]
        cell.textLabel?.text = lesson.lesson?.title
        cell.detailTextLabel?.text = stringFromDate(lesson.date)
        cell.imageView?.image = lesson.lesson?.icon
        
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if User.currUser is Coach {
            let copy = UITableViewRowAction(style: .normal, title: "Copy") { action, index in
                print("Copy")
                self.tableView(tableView, commit: UITableViewCellEditingStyle.insert, forRowAt: indexPath)
            }
        
            copy.backgroundColor = .lightGray
            
            let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
                self.tableView(tableView, commit: UITableViewCellEditingStyle.delete, forRowAt: indexPath)
            }
            delete.backgroundColor = .red
            
            return [copy, delete]
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return User.currUser is Coach
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alertController = UIAlertController(title: "Remove", message: "Are you sure?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ -> Void in
                let item = self.filteredSchedule![indexPath.row]
                do {
                    try self.db.removeScheduleItem(item)
                } catch {
                    fatalError("vse ploho!")
                }
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ -> Void in }))
            self.present(alertController, animated: true, completion: nil)
            
            
        } else if editingStyle == .insert {
            
            let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let editor = sb.instantiateViewController(withIdentifier: "ScheduleItemEdit") as? ScheduleItemEditorController else {
                fatalError("vse ploho!")
            }
            let currItem = filteredSchedule![indexPath.row]
            
            editor.scheduleItem = currItem.copy()
            let nav = UINavigationController(rootViewController: editor)
            self.present(nav, animated: true, completion: nil)
            
        }    
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
        let byTitle = NSPredicate(format: "lesson.title CONTAINS[c] %@", searchText)
        
        switch searchBar.selectedScopeButtonIndex {
        case 0:
            if searchText.isEmpty {
                filteredSchedule = db.schedule
            } else {
                filteredSchedule = db.schedule.filter(byTitle)
            }
        case 1:
            let byWeekDay = NSPredicate(format: "day = 2")
            filterSchedule(withSearchText: searchText, byTitle: byTitle, byWeekDay: byWeekDay)
        case 2:
            let byWeekDay = NSPredicate(format: "day = 3")
            filterSchedule(withSearchText: searchText, byTitle: byTitle, byWeekDay: byWeekDay)
        case 3:
            let byWeekDay = NSPredicate(format: "day = 4")
            filterSchedule(withSearchText: searchText, byTitle: byTitle, byWeekDay: byWeekDay)
        case 4:
            let byWeekDay = NSPredicate(format: "day = 5")
            filterSchedule(withSearchText: searchText, byTitle: byTitle, byWeekDay: byWeekDay)
        case 5:
            let byWeekDay = NSPredicate(format: "day = 6")
            filterSchedule(withSearchText: searchText, byTitle: byTitle, byWeekDay: byWeekDay)
        default:
            filteredSchedule = db.schedule
        }
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search()
    }
    
    private func filterSchedule(withSearchText searchText: String, byTitle: NSPredicate, byWeekDay: NSPredicate){
        if searchText.isEmpty {
            filteredSchedule = db.schedule.filter(byWeekDay)
        } else {
            let filter = NSCompoundPredicate(andPredicateWithSubpredicates: [byWeekDay, byTitle])
            filteredSchedule = db.schedule.filter(filter)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        search()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScheduleItemDetail" {
            guard let controller = segue.destination as? ScheduleItemDetailController else {
                fatalError("Cannot find ScheduleItemDetailController")
            }
            if let row = tableView.indexPathForSelectedRow?.row {
                controller.scheduleItem = filteredSchedule![row]
            }
        }
    }

}

// MARK: - Memento

private enum StateKeys: String {
    case searchState
    case searchTabState
}

extension ScheduleTableView: Restorable {
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

