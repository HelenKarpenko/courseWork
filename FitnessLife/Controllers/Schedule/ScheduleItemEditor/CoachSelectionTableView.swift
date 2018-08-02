//
//  CoachSelectionTableView.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/29/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit
import RealmSwift

class CoachSelectionTableView: UITableViewController {
    
    var onSelect: ((Coach?)->Void)?

    var coaches: Results<Coach>!
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coaches!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoachItem", for: indexPath)
        
        let coach = coaches![indexPath.row]
        cell.textLabel?.text = coach.fullName
        cell.imageView?.image = coach.rank.icon

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coach = coaches![indexPath.row]
        if let onSelect = onSelect {
            onSelect(coach)
        }
        self.dismiss(animated: true, completion: nil)
    }

}
