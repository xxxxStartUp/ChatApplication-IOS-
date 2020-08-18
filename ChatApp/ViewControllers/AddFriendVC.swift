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
        navigationItem.largeTitleDisplayMode = .never
        super.viewDidLoad()
        updateViews()
        updateBackgroundViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.largeTitleDisplayMode = .never
        updateViews()
        updateBackgroundViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationItem.largeTitleDisplayMode = .never
        updateViews()
        updateBackgroundViews()
    }
    

    
    @IBAction func addFriend(_ sender: Any) {
        
        if let email = emailTextfield.text{
            self.searchAndAddFreindWith(email: email)
        }
        
    }
    
    func dynamicLinkSetup(){
        var component = URLComponents()
        component.scheme = "https"
        component.host = "www.example.com"
        //component.path = "\()"
    }
    func updateViews(){
        sendInviteButton.contactsPageButton()
        addContactsHeader.addContactsPageLabels(type: Constants.newContactsPage.newContactsHeader)
        emailTextfield.addContactPage()
    }
    func updateBackgroundViews(){
           DispatchQueue.main.async {
               self.view.darkmodeBackground()
               self.navigationController?.navigationBar.darkmodeBackground()
               self.navigationBarBackgroundHandler()

               
               
           }
       }
       //handles the text color, background color and appearance of the nav bar
       func navigationBarBackgroundHandler(){
           
           if Constants.settingsPage.displayModeSwitch{
               let navBarAppearance = UINavigationBarAppearance()
               navBarAppearance.configureWithOpaqueBackground()
               navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
               navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
               navBarAppearance.backgroundColor = .black
               self.navigationController?.navigationBar.standardAppearance = navBarAppearance
               self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
               self.navigationController?.navigationBar.setNeedsLayout()
               //handles TabBar
               self.tabBarController?.tabBar.barTintColor = .black
               tabBarController?.tabBar.isTranslucent = false
               
               
           }
           else{
               let navBarAppearance = UINavigationBarAppearance()
               navBarAppearance.configureWithOpaqueBackground()
               navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
               navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
               navBarAppearance.backgroundColor = .white
               self.navigationController?.navigationBar.isTranslucent = true
               self.navigationController?.navigationBar.standardAppearance = navBarAppearance
               self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
               self.navigationController?.navigationBar.setNeedsLayout()
               
               //handles TabBar
               self.tabBarController?.tabBar.barTintColor = .white
               self.tabBarController?.tabBar.backgroundColor = .white
               tabBarController?.tabBar.isTranslucent = true
               
           }
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
