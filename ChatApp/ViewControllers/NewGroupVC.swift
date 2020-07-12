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
    @IBOutlet weak var newGroupLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        updateBackgroundViews()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
        updateBackgroundViews()
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
        
        //FireService.sharedInstance.deleteGroup(group: dummyGroup);
        
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "group"{
            
            let destination = segue.destination as! ChatVC
            destination.modalPresentationStyle = .currentContext
            
        }
    }
    func updateViews(){
        //adding rightBarButton
        let rightBarButton = UIButton(type: .system)
        
        rightBarButton.addTarget(self, action: #selector(NewGroupVC.rightBarButtonPressed), for: .touchUpInside)
        
        //allows the cartbutton to glow when it is tapped on
        rightBarButton.showsTouchWhenHighlighted = true
        //sets title of rightbutton
        rightBarButton.setTitle("Done", for: .normal)
        //sets the font size and type.
        rightBarButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 12)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: rightBarButton)]
        newGroupLabel.newGroupPageLabels(type: Constants.newGroupPage.newGroupHeader)
        
    }
    
    @objc func rightBarButtonPressed(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    //updates the background color for the tableview and nav bar.
       func updateBackgroundViews(){
           DispatchQueue.main.async {
               self.view.darkmodeBackground()
               self.navigationController?.navigationBar.darkmodeBackground()
               self.navigationBarBackgroundHandler()
            self.textField.newGroupPageTextField()
               
               
               //self.navigationController?.navigationBar.settingsPage()
               
               
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
//                  textField.attributedPlaceholder = NSAttributedString(string: "Enter Group Name",
//                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
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
//                textField.attributedPlaceholder = NSAttributedString(string: "Enter Group Name",
//                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                 self.navigationController?.navigationBar.standardAppearance = navBarAppearance
                 self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
                 self.navigationController?.navigationBar.setNeedsLayout()
                
                //handles TabBar
                 self.tabBarController?.tabBar.barTintColor = .white
                 tabBarController?.tabBar.isTranslucent = false
             }
         }
       
    
}
