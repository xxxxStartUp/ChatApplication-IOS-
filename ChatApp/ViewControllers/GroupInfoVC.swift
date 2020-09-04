//
//  GroupInfoVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class GroupInfoVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var groupinfoTableview: UITableView!
    @IBOutlet weak var participantsTableview: UITableView!
    @IBOutlet weak var groupNameView: UIView!
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet var groupImageView: UIImageView!
    var defaultImage:UIImage?
    let identifier1 = "GroupchatInfoCellIdentifier"
    
    let identifier2 = "GroupSettingsCellIdentifier"
    
    let identifier3 = "participantsCellIdentifier"
    
    let identifier4 = "participantsHeaderCellIdentifier"
    var groupDelegate : GroupDelegate?
    var groupParticipants = [Friend]()
    var tempParticipants = [Friend]()
    
    var group : Group?{
        didSet{
            title = group?.name
            print(group!,"group")
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        defaultImage = groupImageView.image
        updateBackgroundViews()
        
        setupTableView()
        
        groupNameTextField.delegate = self
        updateGroupName()
        groupPictureGestureSetup()
        
        setImage()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateBackgroundViews()
        setupTableView()
        
    }
    
    func setupTableView(){
        groupinfoTableview.delegate = self
        groupinfoTableview.dataSource = self
        participantsTableview.delegate = self
        participantsTableview.dataSource = self
        groupinfoTableview.register(UINib(nibName: "GroupchatinfoCells", bundle: nil), forCellReuseIdentifier: identifier1)
        groupinfoTableview.register(UINib(nibName: "GroupSettingCell", bundle: nil), forCellReuseIdentifier: identifier2)
        participantsTableview.register(UINib(nibName: "participantsHeaderCell", bundle: nil), forCellReuseIdentifier: identifier4)
        participantsTableview.register(UINib(nibName: "participantsCell", bundle: nil), forCellReuseIdentifier: identifier3)
        
        groupinfoTableview.tableFooterView = UIView()
        participantsTableview.tableFooterView = UIView()
        //participantsTableview.tableHeaderView = UIView()
        
    }
    


    func updateGroupName(){
        FireService.sharedInstance.getGroupname(user: globalUser!, group: group!) { (group, true, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            print(group!.GroupAdmin.email)
            
            self.groupNameTextField.text = group?.name
        }
    }
    //updates the background color for the tableview and nav bar.
    func updateBackgroundViews(){
        DispatchQueue.main.async {
            self.groupinfoTableview.darkmodeBackground()
            self.participantsTableview.darkmodeBackground()
            self.navigationController?.navigationBar.darkmodeBackground()
            self.groupNameView.darkmodeBackground()
            
            
            self.navigationBarBackgroundHandler()
            self.groupinfoTableview.reloadData()
            self.participantsTableview.reloadData()
            //self.navigationController?.navigationBar.settingsPage()
            
            self.groupNameTextField.groupInfoTextField()
            
            
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
extension GroupInfoVC : UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == groupinfoTableview{
            return 2
        }
        else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if tableView == groupinfoTableview{
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 2
        }
            
        else {
            return 0
        }
        }else{
            
        }
        return groupParticipants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        if tableView == groupinfoTableview{
            switch indexPath.section {
            case 0:
                if let cell = groupinfoTableview.dequeueReusableCell(withIdentifier: identifier1) as?  GroupchatinfoCells {
                    
                    //cell.updateviews go here
                    cell.backgroundColor = .clear
                    
                    cell.updateView()
                    
                    return cell
                }
            case 1:
                if let cell = groupinfoTableview.dequeueReusableCell(withIdentifier: identifier2) as? GroupSettingCell{
                    cell.backgroundColor = .clear
                    cell.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    cell.updateViews(indexPath: indexPath.row)
                    return cell
                }
                
                //        case 2:
                //            if let cell = groupinfoTableview.dequeueReusableCell(withIdentifier: identifier3) as? participantsCell  {
                //                cell.backgroundColor = .clear
                //                //cell.updateViews(indexPath: indexPath.row)
                //                return cell
            //            }
            default:
                break
            }
            
        }
        else{
            if let cell = participantsTableview.dequeueReusableCell(withIdentifier: identifier3) as? participantsCell  {
                
                //        Dara used this to test the viewGroupParticipants function in fireservice
                cell.updateViews(groupParticipants:
                self.groupParticipants,indexPath:indexPath.row,group:group!)
                print(self.groupParticipants,"group Participants",indexPath.row)
                cell.backgroundColor = .clear
                return cell
                
            }
            
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == groupinfoTableview{
            if section == 0 {
                let view = UIView()
                view.darkmodeBackground()
                return view
            }
            
            if section == 1 {
                let view = UIView()
                view.darkmodeBackground()
                return view
            }
            
            
        }
        else{
            let view = tableView.dequeueReusableCell(withIdentifier: identifier4) as! participantsHeaderCell
            view.updateviews()
            return view
        }
        
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == groupinfoTableview{
            
            if section == 1 {
                return 0
            }
        }else{
            return 35
        }
        return 40
    }

    
}
extension GroupInfoVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = groupNameTextField.text{
        textField.resignFirstResponder()
        let data = ["groupname":text]
            FireService.sharedInstance.addCustomGroupNameData(data: data, user: globalUser!, group: group!, friends: groupParticipants) { (error, success, isAdmin ) in
                if let error = error{
                    print(error.localizedDescription)
                }
                if success{
                    print("Changed Group Name")
                    //change the name of group for all friends in the group.
                }
                if !isAdmin{
                    self.groupNameTextField.text = self.group?.name
                    print("You're not admin")
                }
            }
        }
        participantsTableview.reloadData()
        return true
    }
}
extension GroupInfoVC:UIImagePickerControllerDelegate{
    
    func presentCameraRoll (sender : UIAlertAction!){
        let cameraRoll = UIImagePickerController()
        cameraRoll.delegate = self
        cameraRoll.sourceType = .photoLibrary
        cameraRoll.allowsEditing = true
        self.present(cameraRoll, animated: true, completion: nil)
    }
    
    func groupPictureGestureSetup(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        groupImageView.isUserInteractionEnabled = true
        groupImageView.addGestureRecognizer(gesture)
    }
    
    @objc func profileImageTapped(){
        let alertController = UIAlertController(title: "What do you want to do?", message: "", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Delete Photo", style: .destructive, handler: deleteImage(sender:))
        let action2 = UIAlertAction(title: "Choose Photo", style: .default, handler: presentCameraRoll(sender:))
        let action3 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actions = [action1,action2,action3]
        
        for action in actions{
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            groupImageView.image = image
            Constants.groupInfoPage.groupImageState = true
            Constants.groupInfoPage.globalGroupImage = image
            
            dismiss(animated: true, completion: nil)
        }
        //sets image to be the edited image.
        else if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            groupImageView.image = image
             Constants.groupInfoPage.groupImageState = true
             Constants.groupInfoPage.globalGroupImage = image
            
            dismiss(animated: true, completion: nil)
        }
        
        let data = Constants.groupInfoPage.globalGroupImage!.pngData()!
        saveGroupPicture(data: data)
   
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func saveGroupPicture(data : Data){
         self.groupImageView.isUserInteractionEnabled = false
        FireService.sharedInstance.saveGroupPicture(data : data , user : globalUser!, group:group!,friend:groupParticipants) { (result) in
            switch result {
            case .success(_):
                print("sucess")
                let image = UIImage(data: data)!
                Constants.groupInfoPage.groupImageState = true
                Constants.groupInfoPage.globalGroupImage = image
                self.groupImageView.image = image
                self.groupImageView.isUserInteractionEnabled = true
            case .failure(_):
                print("falure")
            }
        }
        
        
    }
        func setImage(){
            FireService.sharedInstance.getGroupPictureData(user: globalUser!,group: group!) { (result) in
                switch result{
                    
                case .success(let url):
    //                self.profileImageView.af_setImage(withURL: url)
                    self.groupImageView.loadImages(urlString: url.absoluteString, mediaType: Constants.groupInfoPage.GroupImageType)
                    
                case .failure(_):
                    print("failed to set image url")
                }
                
            }
        }
    func deleteImage (sender : UIAlertAction!){
        groupImageView.image = defaultImage
        deleteGroupPicture()
 
    }
    func deleteGroupPicture(){
         groupImageView.isUserInteractionEnabled = false
        FireService.sharedInstance.DeleteGroupPicture(user: globalUser!, group: group!,friends:groupParticipants) { (result) in
            switch result{
                
            case .success(let bool):
                if bool{
                    Constants.groupInfoPage.globalGroupImage = self.defaultImage
                    Constants.groupInfoPage.groupImageState = true
                    self.groupImageView.isUserInteractionEnabled = true
                    return
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Could not delete", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                 self.groupImageView.isUserInteractionEnabled = true
            }
        }
        
        
        
    }
    
}

