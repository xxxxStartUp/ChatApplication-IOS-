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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addFriend(_ sender: Any) {
        
        if let email = emailTextfield.text{
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
                            }else{
                                if sucess {
                                    print("sucess")
                                }
                            }
                        }
                    }
                }
            }
        }

    }
    
    
}
