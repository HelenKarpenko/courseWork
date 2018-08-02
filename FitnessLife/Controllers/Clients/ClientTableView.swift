//
//  ClientTableView.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/23/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit
import RealmSwift

class ClientTableView: UITableViewController, UISearchBarDelegate {
    
    var notificationToken: NotificationToken!
    
    @IBOutlet weak var addButton: UIButton!
    var filteredClients: Results<Client>?
    var db = DataBase.shared
    var restored = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    func subscribeOnChanges() {
        notificationToken =
            db.clients.observe({ [weak self] change in
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
        filteredClients = db.clients
        self.subscribeOnChanges()
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
    
    @IBAction func addClientButton(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let editor = sb.instantiateViewController(withIdentifier: "ClientEditor") as? ClientEditorController else {
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
        return filteredClients!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientItem", for: indexPath)

        let client = filteredClients![indexPath.row]
        cell.textLabel?.text = client.fullName
        return cell
    }
 
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return User.currUser is Coach
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "Remove", message: "Are you sure?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ -> Void in
                let client = self.filteredClients![indexPath.row]
                do {
                    try self.db.removeClient(client)
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
        if searchText.isEmpty {
            filteredClients = db.clients
        } else {
            filteredClients = db.clients.filter(byFullName)
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search()
//        let byFullName = NSPredicate(format: "fullName CONTAINS[c] %@", searchText)
//        if searchText.isEmpty {
//            filteredClients = db.clients
//        } else {
//            filteredClients = db.clients.filter(byFullName)
//        }
//        tableView.reloadData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClientDetail" {
            guard let controller = segue.destination as? ClientDetailController else {
                fatalError("Cannot find ClientDetailController")
            }
            if let row = tableView.indexPathForSelectedRow?.row {
                controller.clientToShow = db.clients[row]
            }
        }
    }

}

// MARK: - Memento

private enum StateKeys: String {
    case searchState
    case searchTabState
}


extension ClientTableView: Restorable {
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
