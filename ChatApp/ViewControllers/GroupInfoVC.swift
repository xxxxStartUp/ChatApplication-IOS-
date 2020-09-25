//
//  GroupInfoVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

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
    
    let GroupInfoVCToSavedMessagesID = "GroupInfoVCToSavedMessagesID"
    let dynamicLinkDomain = "https://soluchat.page.link"
    var groupDelegate : GroupDelegate?
    var groupParticipants = [Friend]()
    var tempParticipants = [Friend]()
    var messages:[Message]?
    
    var selectedIndexpath:Int?
    var setAdminAndLeaveGroup = false
    var assignAdmin = false
    
    var shareURL:URL? = nil
    var shareURLString:String?
    var groupOptionButton:UIButton?
    
    
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
        setupRightNavItem()
        
        groupNameTextField.delegate = self
        updateGroupName()
        groupPictureGestureSetup()
        participantsTableview.allowsSelection = false
        groupinfoTableview.setEditing(false, animated: false)
        
        
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
        participantsTableview.tableFooterView = footerviewSetUp()
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
    
    @objc func handlesClearButtonRightNavBarItem(sender:UIAlertAction!){
        if let messages = messages{
            FireService.sharedInstance.deleteAllGroupMessages(user: globalUser!, group: group!, MessageToDelete: messages) { (result) in
                
                switch result{
                    
                case .success(let bool):
                    if bool{
                        print("Successfully")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            print("Right Bar button tapped")
        }
    }
    @objc func handlesShareNavBarItem(){
        
        FireService.sharedInstance.getGroupURL(user: globalUser!, group: group!) { (urlString, success, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            if let urlString = urlString,let url = URL(string: urlString){
            let promoText = "Check out this app for solustack"
            let activityVC = UIActivityViewController(activityItems: [promoText,url], applicationActivities: nil)
            self.present(activityVC,animated: true)
        }
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
            
            let rightImage:UIButton = {
                
                let button = UIButton(type: .system)
                
                let image = UIImage(systemName:"pencil")
                
                button.setImage(image, for: .normal)
                button.isUserInteractionEnabled = false
                return button
            }()
            
            
            self.groupNameTextField.rightViewMode = .unlessEditing
            
            self.groupNameTextField.tintColor = #colorLiteral(red: 0.1453940272, green: 0.6507653594, blue: 0.9478648305, alpha: 1)
            
            self.groupNameTextField.rightView = rightImage
            
            
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SavedMessagesVC{
            destination.group = group
            
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
                    tableView.setEditing(false, animated: false)
                    return cell
                }
            case 1:
                if let cell = groupinfoTableview.dequeueReusableCell(withIdentifier: identifier2) as? GroupSettingCell{
                    cell.backgroundColor = .clear
                    cell.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    cell.updateViews(indexPath: indexPath.row)
                    tableView.setEditing(false, animated: false)
                    return cell
                }
                
                
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
        return 0
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
                //                    self.groupImageView.contentMode = .scaleAspectFit
                
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
        FireService.sharedInstance.getGroupPictureData(user: globalUser!, group: group!) { [self] (result) in
            switch result{
                
            case .success(let url):
                FireService.sharedInstance.DeleteGroupPicture(user: globalUser!, group: self.group!,friends:self.groupParticipants) { (result) in
                    switch result{
                        
                    case .success(let bool):
                        if bool{
                            
                            Constants.groupInfoPage.globalGroupImage = self.defaultImage
                            Constants.groupInfoPage.groupImageState = true
                            self.groupImageView.isUserInteractionEnabled = true
                            self.groupImageView.clearCachedImage(url: url.absoluteString)
                            return
                        }
                    case .failure(let error):
                        let alert = UIAlertController(title: "Could not delete", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.groupImageView.isUserInteractionEnabled = true
                    }
                }
                
            case .failure(_):
                print("failed to set image url")
            }
        }

        
        
        
    }
    
}

//handles footerview setup
extension GroupInfoVC{
    func footerviewSetUp() -> UIView{
        let view:UIView = {
            let finalLabel = UIView(frame: CGRect(x: 0, y: 0, width: participantsTableview.frame.width, height: 24))
            finalLabel.backgroundColor = .clear
            return finalLabel
        }()
        let button:UIButton = {
            var groupOptionsButton = UIButton(type: .system)
            groupOptionsButton.frame = view.frame
            groupOptionsButton.setTitle("Group Options", for: .normal)
            groupOptionsButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            //               rightButton.setTitleColor(.red, for: .normal)
            groupOptionsButton.settingsPageButtons()
            groupOptionsButton.translatesAutoresizingMaskIntoConstraints = false
            groupOptionsButton.addTarget(self, action: #selector(handlesLeaveGroupTapped), for: .touchUpInside)
            return groupOptionsButton
        }()
        
        view.addSubview(button)
        groupOptionButton = button
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        return view
    }
    func setupRightNavItem(){
        let clearButton:UIButton = {
            let rightButton = UIButton(type: .system)
            let image = UIImage(systemName: "trash")
            rightButton.setImage(image, for: .normal)
            rightButton.addTarget(self, action: #selector(handlesClearButtonRightNavBarItem), for: .touchUpInside)
            return rightButton
        }()
        let shareButton:UIButton = {
                let rightButton = UIButton(type: .system)
                let image = UIImage(systemName: "square.and.arrow.up")
                rightButton.setImage(image, for: .normal)
                rightButton.addTarget(self, action: #selector(handlesShareNavBarItem), for: .touchUpInside)
                return rightButton
            }()
        let shareRightBarButtonItem = UIBarButtonItem(customView: shareButton)
        navigationItem.rightBarButtonItems = [shareRightBarButtonItem]
        
    }
    
    @objc func handlesLeaveGroupTapped(){
        let alertController = UIAlertController(title: "What do you want to do?", message: "", preferredStyle: .actionSheet)
        
        if !groupParticipants.isEmpty{
        if let groupadmin = group?.GroupAdmin.email{
            
            if groupadmin == globalUser?.email{
                
                
                if groupParticipants.count > 1{
                
                let action1 = UIAlertAction(title: "Assign new admin and leave group", style: .destructive, handler: selectMakeAdminAndLeaveGroupOption(sender:))
                    let action2 = UIAlertAction(title: "Assign admin", style: .default, handler: assignNewAdminOption(sender:))
                let action3 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let action4 = UIAlertAction(title: "Clear Chat", style: .default, handler: handlesClearButtonRightNavBarItem(sender:))
                    
                let actions = [action1,action2,action3,action4]
                
                for action in actions{
                    alertController.addAction(action)
                }
                
                self.present(alertController, animated: true, completion: nil)
            }
                else{
                    let action1 = UIAlertAction(title: "Dissolve group", style: .destructive, handler: dissolveGroup(sender:))
                    let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    let actions = [action1,action2]
                    for action in actions{
                        alertController.addAction(action)
                    }
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else{
                if groupParticipants.contains(globalUser!.asAFriend){
                print("Not admin")
                let action1 = UIAlertAction(title: "Leave group", style: .destructive, handler: leaveGroupOption(sender:))
                let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let action3 = UIAlertAction(title: "Clear Chat", style: .default, handler: handlesClearButtonRightNavBarItem(sender:))
                let actions = [action1,action2,action3]
                
                for action in actions{
                    alertController.addAction(action)
                }
                
                self.present(alertController, animated: true, completion: nil)
                }else{
                    groupOptionButton?.isUserInteractionEnabled = false
                }
            }
        }else{
            groupOptionButton?.isUserInteractionEnabled = false
            }
        }
    }
    func selectMakeAdminAndLeaveGroupOption(sender:UIAlertAction!){
        participantsTableview.reloadData()
        participantsTableview.allowsSelection = true
        setAdminAndLeaveGroup = true
        //        participantsTableview.isEditing = true
        //        participantsTableview.allowsSelectionDuringEditing = true
    }
    func dissolveGroup(sender:UIAlertAction!){
        FireService.sharedInstance.dissolveGroup(user: globalUser!, group: group!) { (error, completion) in
            if let errors = error{
                print(errors.localizedDescription)
                fatalError()
                
            }
            print("dissolved Group")
        }
    }
    
    func assignNewAdminOption(sender:UIAlertAction!){
        participantsTableview.reloadData()
        participantsTableview.allowsSelection = true
        assignAdmin = true
        print("New group admin assigned")
    }
    
    func leaveGroupOption(sender:UIAlertAction!){
    
        FireService.sharedInstance.leaveGroup(user: globalUser!, group: group!, friends: groupParticipants) { (error, success) in
            if let error = error{
                print(error.localizedDescription)
            }
            self.participantsTableview.reloadData()
            
            
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == groupinfoTableview{
            return false
        }
        if tableView == participantsTableview{
            if globalUser?.email == group?.GroupAdmin.email{
                return true
            }
            else{
                return false
            }
        }
     
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if tableView == participantsTableview{
        if editingStyle == .delete{
            
            print("Editing:\(indexPath.row)")
            if groupParticipants.count > 1{
            if let groupadmin = group?.GroupAdmin.email{
                       
                    
                if groupParticipants[indexPath.row].email == groupadmin{
                    let alertController = UIAlertController(title: "Oh no :)", message: "You need to assign a new group admin before leaving the group", preferredStyle: .alert)
                                   
                                   
                    let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(action)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    print("cannot delete group admin")
                }
                        else{
                            FireService.sharedInstance.deleteFriendFromGroup(user: globalUser!, group: group!, friend: groupParticipants[indexPath.row]) { (error, completion) in
                                if let error = error{
                                    print(error.localizedDescription)
                                }
                                print("successfully deleted user from group")
                                self.groupParticipants.remove(at: indexPath.row)
                                self.participantsTableview.reloadData()
                    }
                }
                }
            }
            else{
                let alertController = UIAlertController(title: "Dissolve Group Action", message: "Are you sure you want to go ahead and dissolve the group?", preferredStyle: .alert)
                               
                               
                let action = UIAlertAction(title: "No", style: .cancel, handler: nil)
                let action1 = UIAlertAction(title: "Yes", style: .default, handler: dissolveGroup(sender:))
                let actions = [action,action1]
                      
                      for action in actions{
                          alertController.addAction(action)
                      }
                
                
                self.present(alertController, animated: true, completion: nil)
            }

            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == groupinfoTableview{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupchatInfoCellIdentifier", for: indexPath) as? GroupchatinfoCells{
                if indexPath.row == 0 {
                    performSegue(withIdentifier: GroupInfoVCToSavedMessagesID, sender: self)
                }
                
            }
            
        }
        if tableView == participantsTableview{
            
            if let cell = participantsTableview.dequeueReusableCell(withIdentifier: identifier3) as? participantsCell  {
                
                let alertController = UIAlertController(title: "What do you want to do?", message: "", preferredStyle: .actionSheet)
                
                
                let action1 = UIAlertAction(title: "Make Admin", style: .destructive, handler: setAsAdminClicked(sender:))
                selectedIndexpath = indexPath.row
                
                let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    self.setAdminAndLeaveGroup = false
                    self.assignAdmin = false
                })
                let actions = [action1,action2]
                
                for action in actions{
                    alertController.addAction(action)
                }
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            
        }
    }
    //handles changing the admin to a new user.
    func setAsAdminClicked(sender:UIAlertAction!){
        print("Set this user as admin")
        
        if setAdminAndLeaveGroup == true{
            if let selectedIndexPath = selectedIndexpath {
                self.assignAdmin = false
                let data = ["groupadmin":groupParticipants[selectedIndexPath].email]
                print("This is the \(data["groupadmin"])")
                FireService.sharedInstance.assignAdminAndLeaveGroup(data: data, user: globalUser!, group: group!, friends: groupParticipants) { (error,success, dataReceived) in
                    if let error = error{
                        print(error.localizedDescription)
                    }
                    
                    let user = dataReceived!["user"] as! FireUser
                    let newGroup = dataReceived!["group"] as! Group
                    let friends = dataReceived!["friends"] as! [Friend]
                    
                    print(friends)
                    if success{
                        self.participantsTableview.reloadData()
                        self.group = newGroup
                        self.setAdminAndLeaveGroup = false
                        self.createDynamicLink(admin: newGroup.GroupAdmin, groupID: newGroup.id, groupName: newGroup.name) { (success) in
                            if success{
                                //call function to save the url in FB
                                if let shareURLString = self.shareURLString{
                                    let data = ["groupInvitationUrl" : shareURLString]
                                    FireService.sharedInstance.addCustomDataToGroup(data: data, user: globalUser!, group: newGroup) { (error, success) in
                                        if let error = error {
                                            print(error.localizedDescription)
                                            fatalError()
                                        }
                                        print("Added custom URL data to group")
                                    }
                                }
                            }
                            
                        }
                        print("leavegroupBOOL:\(self.assignAdmin),SETADMINANDLEAVEGROUPBOOL:\(self.setAdminAndLeaveGroup)")
                        //change the name of group for all friends in the group.
                    }
                }
            }
        }else if (assignAdmin == true){
            if let selectedIndexPath = selectedIndexpath {
                self.setAdminAndLeaveGroup = false
                let data = ["groupadmin":groupParticipants[selectedIndexPath].email]
                print("This is the \(data["groupadmin"])")
                FireService.sharedInstance.assignNewAdmin(data: data, user: globalUser!, group: group!, friends: groupParticipants) { (error,success, dataReceived) in
                    if let error = error{
                        print(error.localizedDescription)
                    }
                    
                    let user = dataReceived!["user"] as! FireUser
                    let newGroup = dataReceived!["group"] as! Group
                    let friends = dataReceived!["friends"] as! [Friend]
                    
                    print(friends)
                    if success{
                        self.participantsTableview.reloadData()
                        self.group = newGroup
                        self.assignAdmin = false
                        self.createDynamicLink(admin: newGroup.GroupAdmin, groupID: newGroup.id, groupName: newGroup.name) { (success) in
                            if success{
                                //call function to save the url in FB
                                if let shareURLString = self.shareURLString{
                                    let data = ["groupInvitationUrl" : shareURLString]
                                    FireService.sharedInstance.addCustomDataToGroup(data: data, user: globalUser!, group: newGroup) { (error, success) in
                                        if let error = error {
                                            print(error.localizedDescription)
                                            fatalError()
                                        }
                                        print("Added custom URL data to group")
                                    }
                                }
                            }
                            
                        }
                        print("leavegroupBOOL:\(self.assignAdmin),SETADMINANDLEAVEGROUPBOOL:\(self.setAdminAndLeaveGroup)")
                        
                        //change the name of group for all friends in the group.
                    }
                }
            }
        }
        setAdminAndLeaveGroup = false
        assignAdmin = false
        print("leavegroupBOOL2:\(self.assignAdmin),SETADMINANDLEAVEGROUPBOOL2:\(self.setAdminAndLeaveGroup)")
        
        
    }
    func createDynamicLink(admin:FireUser,groupID:String,groupName:String,completion:@escaping (Bool) -> ()){
        print("this dynamic link func has been called")
        
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "www.example.com"
        components.path = "/groups"
        
        let groupIDQueryItem = URLQueryItem(name: "groupID", value: groupID)
        let adminQueryItem = URLQueryItem(name: "admin", value: admin.email)
        let groupName = URLQueryItem(name: "groupName", value: groupName)
        components.queryItems = [groupIDQueryItem,adminQueryItem,groupName]
        
        guard let linkParameter = components.url else {return}
        
        print("I am sharing \(linkParameter.absoluteString)")
        
        //create the big dynamic link
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: dynamicLinkDomain) else{
            print("Couldn't create FDL components")
            return
        }
        if let myBundleId = Bundle.main.bundleIdentifier{
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        shareLink.iOSParameters?.appStoreID = "962194608"
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Join the chat in the soluchat app"
        shareLink.socialMetaTagParameters?.descriptionText = "This is Soluchat App"
        
        guard let longURL = shareLink.url else{return}
        print("This is the dynamiclink is \(longURL.absoluteString)")
        
        shareLink.shorten { (url, warnings, error) in
            if let error = error {
                print("Shortening Link Error:\(error)")
            }
            if let warnings = warnings{
                for warning in warnings{
                    print("FDL Warning:\(warning)")
                }
            }
            guard let url = url else{return}
            let shortUrl = url.absoluteString
            print("I have a short URL to share! \(url.absoluteString)")
            self.shareURL = url
            self.shareURLString = shortUrl
            
            completion(true)
        }
        
    }
    
    
}


