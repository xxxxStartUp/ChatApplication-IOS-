//
//  ContactInfoVC.swift
//  ChatApp
//
//  Created by ebuka Daniel egbunam on 9/15/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import UIKit

class ContactInfoVC : UIViewController {
    
    @IBOutlet weak var profileImageView : UIImageView!
    
    @IBOutlet weak var contactInfoTableView: UITableView!
    let id = "contactInfoTableView"
    var stopGettingData  = false
    var name : String?
    
    var friend : Friend?{
        
        didSet{
            updateView()
        }
    }
    
    var freindAsUser : FireUser? {
        didSet{
            UpdateImageView()
        }
    }
    override func viewDidLoad() {
        
        print("in contact vc ")
        setUpContactTableview()
    }
    
    func setUpContactTableview(){
        contactInfoTableView.delegate = self
        contactInfoTableView.dataSource = self
        contactInfoTableView.register(ContactInfoCell.self, forCellReuseIdentifier: id)
        contactInfoTableView.estimatedRowHeight = 40
        // contactInfoTableView.rowHeight = UITableView.automaticDimension
    }
    
        
    fileprivate func getUser(){
        
        FireService.sharedInstance.searchOneUserWithEmail(email: friend!.email) { (user, error) in
            guard let user = user else {return}
            self.freindAsUser = user
            self.stopGettingData = true
            return
        }
    }
   fileprivate func updateView(){
        print("Updated View")
    
        name = friend?.username
        getUser()
        
    }
    
    func UpdateImageView(){
        print("updating ImageView")
        FireService.sharedInstance.getProfilePicture(user: freindAsUser!) { (result) in
            switch result {
            case .success(let url):
                self.profileImageView.af.setImage(withURL: url)
                break
            case .failure(_):
                self.profileImageView.image = UIImage(named: "profile")
                break
            }
        }
        
    }
    
    
}



extension ContactInfoVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 3
        }
        
        if section == 2 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = contactInfoTableView.dequeueReusableCell(withIdentifier: id) as? ContactInfoCell else {
            return UITableViewCell()
        }
        
        
        if indexPath.section == 0 {
            cell.ContactInfoLabel.text = name ?? "no name"
        }
        
        if indexPath.section == 1{
            
            if indexPath.row == 0{
                cell.ContactInfoLabel.text = "Saved Messages"
            }
            if indexPath.row == 1{
                cell.ContactInfoLabel.text = "Mute"
                cell.buttonIsSwitch = true
            }
            if indexPath.row == 2{
                cell.ContactInfoLabel.text = "Archive"
                cell.buttonIsSwitch = true
            }
            
        }
        
        if indexPath.section == 2 {
             cell.ContactInfoLabel.text = "Clear Chat"
            // cell.buttonIsSwitch = nil
        }
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
               // go to savedMessaged
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            return nil
        }
        else{
            let size = CGSize(width: contactInfoTableView.frame.width, height: 60)
            let point = CGPoint(x: 0, y: 0)
            let frame = CGRect(origin: point, size: size)
            let space = UIView(frame: frame)
            space.backgroundColor = .clear
            return space
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    
    
    
    
}



class ContactInfoCell : UITableViewCell {
    //if this is true then the button is a switch
    var buttonIsSwitch : Bool = false {
        didSet{
            setUpViews()
        }
    }
    lazy var ContactInfobackgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var ContactInfoLabel : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Testing 123"
        return label
    }()
    
    lazy var ContactInfoswitch : UISwitch = {
        
        let newSwitch = UISwitch()
        newSwitch.translatesAutoresizingMaskIntoConstraints = false
        return newSwitch
    }()
    
    lazy var ContactInfoButton : UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "next"), for: .normal)
        return button
    }()
    
    
    lazy var stackView = UIStackView(arrangedSubviews: [ContactInfoLabel,ContactInfoButton])
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    
    
    
    func setUpViews(){
        
        if buttonIsSwitch{
              stackView = UIStackView(arrangedSubviews: [ContactInfoLabel,ContactInfoswitch])
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.backgroundColor = .green
        self.addSubview(ContactInfobackgroundView)
        self.addSubview(stackView)
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.distribution = .fill
        
        //constaint for ContactInfobackgroundView
        ContactInfobackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        ContactInfobackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        ContactInfobackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        ContactInfobackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        //consstarint for stackView
        
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        
        
        if buttonIsSwitch{
   ContactInfoswitch.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
    
        }else{
            ContactInfoButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        }
        //  constarint for ContactInfoswitch and ContactInfoButton
      
        //  ContactInfoswitch.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
