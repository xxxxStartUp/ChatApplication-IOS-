//
//  NotificationsVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/6/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var notificationsTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.notificationsCellIdentifier, for: indexPath) as! NotificationsCell
        cell.updateViews()
        cell.backgroundColor = .clear
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        notificationsTableView.register(UINib(nibName: "NotificationsCell", bundle: nil), forCellReuseIdentifier: Constants.Identifiers.notificationsCellIdentifier)
        navigationItem.title = "Notifications"
        navigationController?.navigationBar.prefersLargeTitles = true
        notificationsTableView.tableFooterView = UIView()
        DispatchQueue.main.async {
            self.navigationBarBackgroundHandler()
            self.navigationController?.navigationBar.setNeedsLayout()
        }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateBackgroundViews()
    }
    //updates the background color for the tableview and nav bar.
    func updateBackgroundViews(){
        print("The bool is \(Constants.settingsPage.displayModeSwitch)")
        DispatchQueue.main.async {
            self.notificationsTableView.darkmodeBackground()
            self.navigationBarBackgroundHandler()
            self.navigationController?.navigationBar.darkmodeBackground()
            self.notificationsTableView.reloadData()
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
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
            //lets it update instantly
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
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            self.navigationController?.navigationBar.setNeedsLayout()
            
            //handles TabBar
             self.tabBarController?.tabBar.barTintColor = .white
             tabBarController?.tabBar.isTranslucent = false
        }
    }
    
    
}
