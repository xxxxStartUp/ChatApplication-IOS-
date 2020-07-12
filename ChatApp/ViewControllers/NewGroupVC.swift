//
//  CreateGroupVC.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/24/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class NewGroupVC: UIViewController {
    
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var newGroupLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        // Do any additional setup after loading the view.
    }
    

    
    func createGroup() {
        if let groupName = self.groupNameTextField.text{
            if groupName == "" {
                let controller = UIAlertController.alertUser(title: "Error", message: "Add a name to the groupchat", whatToDo: "Try again")
                self.present(controller, animated: true, completion: nil)
                return
            }
            
            
            let newGroup = Group(GroupAdmin: globalUser!, id: 1, name: groupName)
            
            FireService.sharedInstance.createGroup(group: newGroup) { (completed, error) in
                if let error = error{
                    print(error.localizedDescription)
                    fatalError()
                }
                
                if completed{
                    self.goToTab()
                                      
                }
                
                
                
            }
            
            
        }
        
        
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
        createGroup()
       // navigationController?.popToRootViewController(animated: true)
    }
    
}
