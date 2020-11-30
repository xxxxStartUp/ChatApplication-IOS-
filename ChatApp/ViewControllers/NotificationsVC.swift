//
//  NotificationsVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/6/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController{
    @IBOutlet weak var notificationsTableView: UITableView!
    
    var notificationDataList = [NotificationModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        
        FireService.sharedInstance.getNotificationLog { (rawdata, error) in
            if(error != nil){
                print(error?.localizedDescription)
            }
            if let data = rawdata{
                self.notificationDataList = data
                self.notificationsTableView.reloadData()
            }
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
            self.view.darkmodeBackground()
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


extension NotificationsVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableview count = \(self.notificationDataList.count)")
        return self.notificationDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notification = notificationDataList[indexPath.row]
        
        if(notification.photo_url == ""){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)//without photo
            let title = cell.viewWithTag(2) as! UILabel
            let subtitle = cell.viewWithTag(3) as! UILabel
            let timeStamp = cell.viewWithTag(4) as! UILabel
            title.text = notification.title
            subtitle.text = notification.subtitle
            timeStamp.text = notification.timeStamp.DateConvert("dd/MM/yy HH:mmaa")
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let notificationPhoto = cell.viewWithTag(1) as! UIImageView
            let title = cell.viewWithTag(2) as! UILabel
            let subtitle = cell.viewWithTag(3) as! UILabel
            let timeStamp = cell.viewWithTag(4) as! UILabel
            notificationPhoto.layer.cornerRadius = CGFloat(65/2)
            notificationPhoto.loadImages(urlString: notification.photo_url, mediaType: Constants.profilePage.profileImageType)
            title.text = notification.title
            subtitle.text = notification.subtitle
            timeStamp.text = notification.timeStamp.DateConvert("dd/MM/yy HH:mmaa")
            return cell
        }
        print(notification)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let notification = notificationDataList[indexPath.row]
        let accept = UIContextualAction(style: .normal, title: "Accept") { (action, view, nil) in
            print("Accept")
            if(notification.dynamicLink != ""){
                self.openURLInApp(request: notification.dynamicLink)
                FireService.sharedInstance.notificationDelete(notification.id) { (isSuccess, error) in
                    if error != nil{
                        print(error)
                    }
                }
            }
        }
        let reject = UIContextualAction(style: .normal, title: "Reject") { (action, view, nil) in
            print("Reject")
            FireService.sharedInstance.notificationDelete(notification.id) { (isSuccess, error) in
                if error != nil{
                    print(error)
                }
            }
        }
        reject.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        accept.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        let config = UISwipeActionsConfiguration(actions: [accept,reject])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    
}
