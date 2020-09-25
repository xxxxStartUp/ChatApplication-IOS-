//
//  SavedMessagesVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 9/4/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class SavedMessagesFromSettingsVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet var savedMessagesTable: UITableView!
    let identifier1 = "GroupchatInfoCellIdentifier"
    var cellID = "id"
    
    var savedMessagesDictionary : [String:Message] = [:]
    var savedMessagesKeys:[String] = []
    var savedMessages:[Message] = []
    
    var group: Group?
    var finalLabel:UILabel?
    var rightBarButton:UIBarButtonItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBackgroundViews()
        setupTableView()
        loadMessages()
        setupRightNavItem()
        self.handleEmptySavedMessages()
        savedMessagesTable.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateBackgroundViews()
        finalLabel?.settingsPageLabels(type: Constants.settingsPage.labelTitles)
        loadMessages()
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateBackgroundViews()
        loadMessages()
        
        
        
    }
    
    func setupTableView(){
        savedMessagesTable.delegate = self
        savedMessagesTable.dataSource = self
        savedMessagesTable.register(MessgaeCell.self, forCellReuseIdentifier: cellID)
    }
    func setupRightNavItem(){
        let button:UIButton = {
            let rightButton = UIButton(type: .system)
            let image = UIImage(systemName: "minus.circle.fill")
            rightButton.setImage(image, for: .normal)
            rightButton.addTarget(self, action: #selector(handlesTappedRightNavBarItem), for: .touchUpInside)
            return rightButton
        }()
        
        var keywindow = UIWindow()
        for window in UIApplication.shared.windows{
            if window.isKeyWindow{
                keywindow = window
            }
        }
        let label:UILabel = {
            let finalLabel = UILabel(frame: keywindow.frame)
            finalLabel.text = "No Saved Messages"
            finalLabel.textAlignment = .center
            finalLabel.center = keywindow.center
            return finalLabel
        }()
        
        finalLabel = label
        savedMessagesTable.addSubview(finalLabel!)
        
        finalLabel?.isHidden = true
        finalLabel?.settingsPageLabels(type: Constants.settingsPage.labelTitles)
        
        let rightBarButtonItem = UIBarButtonItem(customView: button)
        rightBarButton = rightBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    @objc func handlesTappedRightNavBarItem(){

        savedMessagesTable.setEditing(true, animated: true)
        
        print("Right Bar button tapped")
        
    }
    func loadMessages (){
        
        FireService.sharedInstance.loadSavedMessagesFromSettings(user: globalUser!) { (messages, error) in

            if let error = error{
                print(error.localizedDescription)
            }

            print("savedmessagesfrom settings count:\(self.savedMessages.count)")
            self.savedMessages.removeAll()
            self.savedMessagesTable.reloadData()
            guard let messages = messages else {return}
            print(messages.count , "this is printing is in groupvc")

            messages.forEach { (message) in
                self.savedMessages.append(message)
                print(message.content.content as! String, "this is printing in group vc")
            }


            self.savedMessages.sort { (message1, message2) -> Bool in
                return message1.timeStamp < message2.timeStamp
            }

            if !messages.isEmpty{
                self.savedMessagesTable.reloadData()
                self.savedMessagesTable.separatorStyle = .singleLine
                self.finalLabel?.isHidden = true
                let indexPath = IndexPath(row: self.savedMessages.count-1, section: 0)
                self.savedMessagesTable.scrollToRow(at:indexPath, at: .bottom, animated: true)
                print(self.savedMessages[0].content.content)
            }
            else{
                self.savedMessagesTable.scrollsToTop = true
                self.savedMessagesTable.separatorStyle = .none
                self.finalLabel?.isHidden = false

            }
            //            if self.savedMessages.isEmpty{
            //                   self.savedMessagesTable.separatorStyle = .none
            //                   self.finalLabel?.isHidden = false
            //               }
            //               else{
            //                   self.savedMessagesTable.separatorStyle = .singleLine
            //                   self.finalLabel?.isHidden = true
            //               }

        }
        print("\(savedMessages.count)")
        
    }
    //updates the background color for the tableview and nav bar.
    func updateBackgroundViews(){
        print("Display switch:\(Constants.settingsPage.displayModeSwitch)")
        navigationItem.title = "Saved Messages"
        DispatchQueue.main.async {
            self.savedMessagesTable.darkmodeBackground()
            
            //self.navigationController?.navigationBar.darkmodeBackground()
            
            self.navigationBarBackgroundHandler()
            
        }
    }
    func handleEmptySavedMessages(){
        if self.savedMessages.isEmpty{
            self.savedMessagesTable.separatorStyle = .none
            self.finalLabel?.isHidden = false
        }
        else{
            self.savedMessagesTable.separatorStyle = .singleLine
            self.finalLabel?.isHidden = true
        }
    }
    //handles the text color, background color and appearance of the nav bar
    func navigationBarBackgroundHandler(){
        
        print("Display switch:\(Constants.settingsPage.displayModeSwitch)")
        if Constants.settingsPage.displayModeSwitch{
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .black
            self.navigationController?.navigationBar.isTranslucent = false
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
    
    
}


extension SavedMessagesFromSettingsVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberofrows: \(savedMessages.count)")
        return savedMessages.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = savedMessagesTable.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MessgaeCell
        let message = savedMessages[indexPath.row]
        cell.message = message
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let message = savedMessages[indexPath.row]
            print(savedMessages[indexPath.row].content)
            FireService.sharedInstance.deleteSavedMessageFromSettings(user: globalUser!, MessageToDelete: message) { (result) in
                switch result{
                    
                case .success(let bool):
                    if bool{
                        print("Saved Messages:\(self.savedMessages.count)")
                        self.savedMessages.remove(at: indexPath.row)
                        self.savedMessagesTable.deleteRows(at: [indexPath], with: .automatic)
                        self.savedMessagesTable.setEditing(false, animated: false)
                        self.handleEmptySavedMessages()
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            
            
        }
    }

}
