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
        let dummyUser = FireUser(userID: 1, userName: "kbhwh", userEmail: "wow3@gmail.com", creationDate: Date())
        let dummyGroup = Group(GroupAdmin: dummyUser, id: 1, name: "group1")
        
//        FireService.sharedInstance.createGroup(group: dummyGroup) { (completed, error) in
//            if let error = error{
//                print(error.localizedDescription)
//                fatalError()
//            }
//
//            if completed{
//                if let groupName = self.groupName.text{
//                    if groupName != "" {
//                               //check if texfield is empty
//                        self.performSegue(withIdentifier: "group", sender: self)
//                    }else{
//                       let controller = UIAlertController.alertUser(title: "Error", message: "Add a name to the groupchat", whatToDo: "Try again")
//                        self.present(controller, animated: true, completion: nil)
//                    }
//
//
//                }
//
//
//            }
//        }
        
        FireService.sharedInstance.deleteGroup(group: dummyGroup);
        
        
 
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "group"{
            
            let destination = segue.destination as! ChatVC
            destination.modalPresentationStyle = .currentContext
        }
    }

}
