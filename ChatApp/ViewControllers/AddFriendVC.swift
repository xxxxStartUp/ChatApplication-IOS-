//
//  AddFiend.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/29/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import UIKit

class AddFriendVC : UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var sendInviteButton: UIButton!
    @IBOutlet weak var addContactsHeader: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func addFriend(_ sender: Any) {
        
        if let email = emailTextfield.text{
            self.searchAndAddFreindWith(email: email)
        }
        
    }
    func updateViews(){
        sendInviteButton.contactsPageButton()
        addContactsHeader.contactsPageLabels(type: Constants.newContactsPage.newContactsHeader)
    }
    
    
    
    
    
    
    func searchAndAddFreindWith(email : String)  {
        
        FireService.sharedInstance.searchOneFreindWithEmail(email: email) { (freind, error) in
            if let error = error {
                print(error)
                fatalError("cannot add friend, deoes not exsist")
            }else{
                
                
                if let friend = freind {
                    guard let globalUser = globalUser else {return}
                    FireService.sharedInstance.addFriend(User: globalUser, friend: friend) { (sucess, error) in
                        
                        if let error = error{
                            print(error)
                            
                            let controller = UIAlertController.alertUser(title: "Error", message: error.localizedDescription, whatToDo:  "make sure the email is complete")
                            self.present(controller, animated: true, completion: nil)
                        }else{
                            if sucess {
                                print("sucess")
                                let controller = UIAlertController.alertUser(title: "Sucesss", message: "Sucessfully added a user", whatToDo: "Check contact sb")
                                
                                self.present(controller, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
