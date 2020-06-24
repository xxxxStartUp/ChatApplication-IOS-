//
//  CreateGroupVC.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/24/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class NewGroupVC: UIViewController {

    
    @IBOutlet weak var groupName: UITextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func Done(_ sender: Any) {
        
        
        if let groupName = groupName.text{
            if groupName != "" {
                       //check if texfield is empty
                 performSegue(withIdentifier: "group", sender: self)
            }else{
               let controller = UIAlertController.alertUser(title: "Error", message: "Add a name to the groupchat", whatToDo: "Try again")
                present(controller, animated: true, completion: nil)
            }
           
            
        }
 
        
        
        //check if groupname already exists
        
        
        
        //get group collection data
        
        //segue to group
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "group"{
            
            let destination = segue.destination as! ChatVC
            destination.modalPresentationStyle = .currentContext
        }
    }

}
