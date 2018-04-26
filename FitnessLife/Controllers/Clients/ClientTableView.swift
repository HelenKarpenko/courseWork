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
    
    var filteredClients = [IClient]()
    var db = DataBase.shared
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func configure() {
        // subscibe for changes
        notificationToken =
            db.privateClients.observe({ [weak self] change in
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
        
//        clients = Array(db.clients.values)
//        filteredClients = clients
        self.configure()
        tableView.reloadData()
        searchBar.delegate = self
    }
    
    @IBAction func addClientButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let privateAction = UIAlertAction(title: "Private", style: .default) { (_) in
            self.showClientEditor(ofType: .privateType, withCreator: PrivateClientCreator() as ICreator)
        }
        let corporateAction = UIAlertAction(title: "Corporate", style: .default) { _ in
            self.showClientEditor(ofType: .corporateType, withCreator: CorporateClientCreator() as ICreator)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(privateAction)
        alert.addAction(corporateAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion:  nil)
    }
    
    func showClientEditor(ofType type: ClientType, withCreator creator: ICreator) {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let editor = sb.instantiateViewController(withIdentifier: "ClientEditor") as? ClientEditorController else {
            fatalError("vse ploho!")
        }
//        editor.type = type
        editor.creator = creator
        let nav = UINavigationController(rootViewController: editor)
        self.present(nav, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return filteredClients.count
        return db.privateClients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientItem", for: indexPath)
        let client = db.privateClients[indexPath.row]
//        let client = filteredClients[indexPath.row]
        cell.textLabel?.text = client.fullName
//        if(client is PrivateClient) {
            cell.detailTextLabel?.text = "Private"
//        } else {
//            cell.detailTextLabel?.text = "Corporate"
//        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
//            let client = filteredClients[indexPath.row]
//            db.removeClient(client)
//            if let index = self.clients.index(where: { $0.id == client.id }) {
//                self.clients.remove(at: index)
//            }
//            self.filteredClients.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        } else if editingStyle == .insert {
            print("error")
        }
    }

    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        let itemToMove = filteredClients[fromIndexPath.row]
//        filteredClients.remove(at: fromIndexPath.row)
//        filteredClients.insert(itemToMove, at: fromIndexPath.row)
//    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    // MARK: - Search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredClients = clients.filter({ client -> Bool in
//            let fullName = client.fullName
//            switch searchBar.selectedScopeButtonIndex {
//            case 0:
//                if searchText.isEmpty { return true }
//                return fullName.lowercased().contains(searchText.lowercased())
//            case 1:
//                if searchText.isEmpty { return client is PrivateClient }
//                return fullName.lowercased().contains(searchText.lowercased()) &&
//                    client is PrivateClient
//            case 2:
//                if searchText.isEmpty { return client is CorporateClient }
//                return fullName.lowercased().contains(searchText.lowercased()) &&
//                    client is CorporateClient
//            default:
//                return false
//            }
//        })
//        tableView.reloadData()
    }
    
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        switch selectedScope {
//        case 0:
//            filteredClients = clients
//        case 1: filteredClients = clients.filter({ client -> Bool in
//            client is PrivateClient
//        })
//        case 2: filteredClients = clients.filter({ client -> Bool in
//            client is CorporateClient
//        })
//        default:
//            break
//        }
//        tableView.reloadData()
//    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClientDetail" {
            guard let controller = segue.destination as? ClientDetailController else {
                fatalError("Cannot find ClientDetailController")
            }
            if let row = tableView.indexPathForSelectedRow?.row {
                controller.client = db.privateClients[row]
            }
        }
    }

}
