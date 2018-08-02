//
//  SignUp.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/30/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

class SignUp: UITableViewController {

    let db = DataBase.shared
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        fullName.delegate = self
        email.delegate = self
        phone.delegate = self
        address.delegate = self
        password.delegate = self
        repeatPassword.delegate = self
    }

    @IBAction func signUp(_ sender: Any) {
        let userFullName = fullName.text
        let userEmail = email.text
        let userPhone = phone.text
        let userAddress = address.text
        let userPassword = password.text
        let userRepeatPassword = repeatPassword.text
        
        
        if((userFullName?.isEmpty)! ||
            (userEmail?.isEmpty)! ||
            (userPhone?.isEmpty)! ||
            (userAddress?.isEmpty)! ||
            (userPassword?.isEmpty)! ||
            (userRepeatPassword?.isEmpty)!) {
            
            displayAlertMessage(userMessage: "All fields are required")
            return
        }
        
        if(userPassword != userRepeatPassword) {
            displayAlertMessage(userMessage: "Password != RepeatPassword")
            return
        }
        
        if(db.emailIsExists(userEmail!)){
            displayAlertMessage(userMessage: "Email already exists")
            return
        }
        
        let creator = ClientCreator()
        let newUser = creator.createUser(withFullName: userFullName!,
                                         withPhone: userPhone!,
                                         withEmail: userEmail!,
                                         withAddress: userAddress!,
                                         withPassword: userPassword!)
        
        do {
            try db.addNewClient(newUser as! Client)
            self.dismiss(animated: true, completion: nil)
        } catch {
            fatalError("vse ploho!")
        }
        
    }
    @IBAction func signIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayAlertMessage(userMessage:String){
        
        let alert = UIAlertController(title:"Error", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let ok = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alert.addAction(ok);
        self.present(alert, animated:true, completion:nil);
        
    }
}

extension SignUp: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
}
