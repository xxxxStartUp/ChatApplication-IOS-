//
//  SettingsVC.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/21/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var SettingsTable: UITableView!
    @IBOutlet weak var signOutButton: UIButton!
    
    //let identifier = "SettingsProfileCell"
    let identifier = "profileInfoCellIdentifier"
    //let identifier2 = "SettingsCell"
    let identifier2 = "ChatActionsCellsIdentifier"
    
    let identifier3 = "AppSettingsCellIdentifier"
    let settingsVCToSavedMessagesID = "settingsVCToSavedMessagesID"
    var logOutButton:UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshCurrentUser()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Settings"
        //navigationController?.navigationBar.backgroundColor = .lightGray
        setUpTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(on), name: .displayOn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(off), name: .displayOff, object: nil)
        
        self.updateBackgroundViews()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func on (){

        self.updateBackgroundViews()
        
        
    }
    
    @objc func off (){

        self.updateBackgroundViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateBackgroundViews()
        SettingsTable.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }

    func setUpTableView() -> Void {
        SettingsTable.delegate = self
        SettingsTable.dataSource = self
        SettingsTable.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "profileInfoCellIdentifier")
        SettingsTable.register(UINib(nibName: "ChatInfoCells", bundle: nil), forCellReuseIdentifier: "ChatActionsCellsIdentifier")
        SettingsTable.register(UINib(nibName: "AppSettingsCell", bundle: nil), forCellReuseIdentifier: "AppSettingsCellIdentifier")
        SettingsTable.tableFooterView = footerviewSetUp()
        // SettingsTable.settingsPage()
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .displayOn, object: nil)
         NotificationCenter.default.removeObserver(self, name: .displayOff, object: nil)
    }
    
    
}


extension SettingsVC : UITableViewDataSource , UITableViewDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 1
        }
            
        else if section == 2 {
            return 2
        }
        else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if let cell = SettingsTable.dequeueReusableCell(withIdentifier: identifier) as?  ProfileInfoCell {
                
                //cell.updateviews go here
                cell.backgroundColor = .clear
                
                cell.updateViews()
                
                return cell
            }
        case 1:
            if let cell = SettingsTable.dequeueReusableCell(withIdentifier: identifier2) as?  ChatInfoCells {
                cell.backgroundColor = .clear
                cell.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.updateView(indexPath: indexPath.row)
                return cell
            }
        case 2:
            if let cell = SettingsTable.dequeueReusableCell(withIdentifier: identifier3) as?  AppSettingsCell {
                cell.backgroundColor = .clear
                cell.updateViews(indexPath: indexPath.row)
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        if section == 1 {
            let view = UIView()
            view.darkmodeBackground()
            return view
        }
        
        if section == 2 {
            let view = UIView()
            view.darkmodeBackground()
            return view
        }
        
        if section == 3 {
            let view = UIView()
            view.darkmodeBackground()
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section ==  3 {
            return 100
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: Constants.settingsToProfileIdentifer, sender: self)
        case 1:
            if indexPath.row == 0{
                performSegue(withIdentifier: settingsVCToSavedMessagesID, sender: self)
            }
            
        default:
               break
     
    }
        
    }
    
    //updates the background color for the tableview and nav bar.
    func updateBackgroundViews(){
        DispatchQueue.main.async {
            self.SettingsTable.darkmodeBackground()
            self.navigationController?.navigationBar.darkmodeBackground()
            //self.signOutButton.settingsPageButtons()
            self.logOutButton?.settingsPageButtons()
            self.navigationBarBackgroundHandler()
            self.view.darkmodeBackground()
            self.SettingsTable.reloadData()
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

extension Notification.Name {
    static let displayOn
        = NSNotification.Name("displayOn")
    static let displayOff
        = NSNotification.Name("displayOff")
    
    
}
extension SettingsVC{
    func footerviewSetUp() -> UIView{
        let view:UIView = {
            let finalLabel = UIView(frame: CGRect(x: 0, y: 0, width: SettingsTable.frame.width, height: 24))
            finalLabel.backgroundColor = .clear
            return finalLabel
        }()
        let button:UIButton = {
            var logoutButton = UIButton(type: .system)
            logoutButton.frame = view.frame
            logoutButton.setTitle("Log out", for: .normal)
            logoutButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            //               rightButton.setTitleColor(.red, for: .normal)
            logoutButton.settingsPageButtons()
            logoutButton.translatesAutoresizingMaskIntoConstraints = false
            logoutButton.addTarget(self, action: #selector(handlesSignoutTapped), for: .touchUpInside)
            return logoutButton
        }()
        
        view.addSubview(button)
        logOutButton = button
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        return view
    }
   @objc func handlesSignoutTapped(){
        refreshCurrentUser()
        let alert = UIAlertController(title: "Are you sure to Logout?", message: "", preferredStyle: .actionSheet)
        
    
        let action = UIAlertAction(title: "Logout", style: .destructive) { (alert) in
            if(globalUser.toFireUser.deviceToken == Constants.deviceTokenKey.load()){
                FireService.sharedInstance.addCustomData(data: ["deviceToken":""], user: globalUser.toFireUser)
                                                 { (error, completion) in
                                                     if let error = error{
                                                         print("error \(error)")
                                                        self.snackbar("Failed to Sign Out")
                                                     }else{
                                                        FireService.sharedInstance.signOut()
                                                        globalUser = nil
                                                        self.goToLogin()
                                                     }
                                                 }
            }else{
                   FireService.sharedInstance.signOut()
                   globalUser = nil
                   self.goToLogin()
            }
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .default) { (alert) in
            
        }
        
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
        
    
    }
}
