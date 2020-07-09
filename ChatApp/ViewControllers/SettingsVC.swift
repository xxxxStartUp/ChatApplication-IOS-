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
    
    //let identifier = "SettingsProfileCell"
    let identifier = "profileInfoCellIdentifier"
    //let identifier2 = "SettingsCell"
    let identifier2 = "ChatActionsCellsIdentifier"
    
    let identifier3 = "AppSettingsCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Settings"
        //navigationController?.navigationBar.backgroundColor = .lightGray
        setUpTableView()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func setUpTableView() -> Void {
        SettingsTable.delegate = self
        SettingsTable.dataSource = self
        SettingsTable.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "profileInfoCellIdentifier")
        SettingsTable.register(UINib(nibName: "ChatInfoCells", bundle: nil), forCellReuseIdentifier: "ChatActionsCellsIdentifier")
        SettingsTable.register(UINib(nibName: "AppSettingsCell", bundle: nil), forCellReuseIdentifier: "AppSettingsCellIdentifier")
        SettingsTable.tableFooterView = UIView()
        
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
            return 2
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
        
//        if indexPath.section == 0 {
//            if let cell = SettingsTable.dequeueReusableCell(withIdentifier: identifier) as?  ProfileInfoCell {
//                cell.backgroundColor = .clear
//                return cell
//            }
//        }
//        else {
//            if let cell = SettingsTable.dequeueReusableCell(withIdentifier: identifier2) as?  ChatInfoCells {
//                cell.backgroundColor = .clear
//                return cell
//            }
//        }
//
//        //        if indexPath.section == 1 {
//        //            let cell = UITableViewCell()
//        //            cell.textLabel?.text = "section1"
//        //            return cell
//        //        }
//        //
//        //        if indexPath.section == 2 {
//        //            let cell = UITableViewCell()
//        //            cell.textLabel?.text = "section2"
//        //            return cell
//        //        }
//        //
//        //        if indexPath.section == 3 {
//        //            let cell = UITableViewCell()
//        //            cell.textLabel?.text = "section3"
//        //            return cell
//        //        }
//
//
//
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        if section == 1 {
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            return view
        }
        
        if section == 2 {
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            return view
        }
        
        if section == 3 {
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
    
}
