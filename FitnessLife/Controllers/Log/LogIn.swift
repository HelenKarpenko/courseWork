//
//  LogIn.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/30/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

class LogIn: UITableViewController {

    let db = DataBase.shared
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        email.delegate = self
        password.delegate = self
        
    }
    
    @IBAction func signIn(_ sender: Any) {
        let userEmail = email.text
        let userPassword = password.text
        
        
        if((userEmail?.isEmpty)! || (userPassword?.isEmpty)!) {
            displayAlertMessage(userMessage: "All fields are required")
            return
        }
        
        let user = Client.find(byEmail: userEmail!, password: userPassword!)
        if user == nil {
            displayAlertMessage(userMessage: "User NOT exists")
            return
        }
        
        User.currUser = user
    
        performSegue(withIdentifier: "LoginSuccessfully", sender: nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        
    }

    func displayAlertMessage(userMessage:String){
        
        let alert = UIAlertController(title:"Error", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let ok = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alert.addAction(ok);
        self.present(alert, animated:true, completion:nil);
        
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSuccessfully" {
            guard let tab = segue.destination as? UITabBarController,
                let nav = tab.viewControllers![0] as? UINavigationController,
                let _ = nav.topViewController as? ClientDetailController
                else {
                    fatalError("Cannot find ScheduleTableView")
            }
            
            tab.selectedIndex = StateManager.shared.mainTabIndex
        }
    }

}

extension LogIn: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
}
