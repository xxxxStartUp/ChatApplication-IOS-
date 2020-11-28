//
//  ProfileVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/7/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileVC: UIViewController,UIPickerViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate ,  UITextFieldDelegate {
    
    @IBOutlet weak var nameHeader: UILabel!
    @IBOutlet weak var emailHeader: UILabel!
    @IBOutlet weak var statusHeader: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    var defaultImage : UIImage?
    var name : String = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setImage()
        updateViews()
        updateBackgroundViews()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        defaultImage = profileImageView.image
        profilePictureGestureSetup()
        updateViews()
        updateBackgroundViews()
        statusTextFieldGestureSetup()
        nameTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
       
        
        // Do any additional setup after loading the view.
        
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        navigationController?.navigationBar.prefersLargeTitles = true
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.navigationBar.prefersLargeTitles = true
//    }
    
    @objc func keyboardWillShow(){
        name = nameTextField.text ?? ""
        print("inserted name" , name)
       }
       
    
    @objc func keyboardDidHide(){
        
        if name == "" {return}
        
        if nameTextField.text != ""{
            if let newName = nameTextField.text {
                if newName == name {
                    return
                }
                name = newName
                
                let alert = UIAlertController(title: "Changing your name", message: "Are you sure you want to chnage your name?", preferredStyle: .actionSheet)
                
                let action = UIAlertAction(title: "Yes", style: .default, handler: changeName(sender:))
                
                let action2 = UIAlertAction(title: "No", style: .cancel, handler: nil)
                
                alert.addAction(action)
                alert.addAction(action2)
                present(alert, animated: true, completion: nil)
            }
            
            

        }
       
    }
    
    
    func changeName(sender : UIAlertAction){
        FireService.sharedInstance.addCustomData(data: ["username":name], user: globalUser.toFireUser) { (error, sucess) in
            if sucess {
                print("name was chnaged")
                
                FireService.sharedInstance.refreshUserInfo(email: globalUser.toFireUser.email)
            }
            
        }
        
    }
    
  
    //handles the updating of the views ....color, font, size etc.
    func updateViews(){
        
        nameHeader.profilePageLabels(type: Constants.profilePage.headers)
        emailHeader.profilePageLabels(type: Constants.profilePage.headers)
        statusHeader.profilePageLabels(type: Constants.profilePage.headers)
        nameTextField.profilePageTextFields(type: Constants.profilePage.textfields)
        
        let textFieldIcon = UIImageView( image: UIImage(systemName: "pencil.circle.fill")?.withRenderingMode(.alwaysOriginal))
        let textFieldIcon2 =  UIImageView( image: UIImage(systemName: "pencil.circle.fill")?.withRenderingMode(.alwaysOriginal))
        textFieldIcon.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let textFieldIcon3 =  UIImageView( image: UIImage(systemName: "pencil.circle.fill")?.withRenderingMode(.alwaysOriginal))
        textFieldIcon.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        nameTextField.rightView = textFieldIcon
        nameTextField.rightViewMode = UITextField.ViewMode.unlessEditing
        nameTextField.profilePageTextFields(type: Constants.profilePage.textfields)
        
        //statusTextField.isUserInteractionEnabled = false
        statusTextField.allowsEditingTextAttributes = false
        statusTextField.rightView = textFieldIcon2
        statusTextField.rightViewMode = UITextField.ViewMode.unlessEditing
        statusTextField.profilePageTextFields(type: Constants.profilePage.textfields)
        
        emailTextField.isUserInteractionEnabled = false
        emailTextField.rightView = textFieldIcon3
//        emailTextField.rightViewMode = UITextField.ViewMode.unlessEditing
        emailTextField.profilePageTextFields(type: Constants.profilePage.textfields)
        
        nameView.profilePageViews()
        emailView.profilePageViews()
        statusView.profilePageViews()
        profileImageView.profilePageImageView()
        
        //sets the email textfield name and name textfield.
        nameTextField.text = globalUser.toFireUser.name
        emailTextField.text = globalUser.toFireUser.email
        
        nameView.layer.cornerRadius = 10
        emailView.layer.cornerRadius = 10
        statusView.layer.cornerRadius = 10
        
    }
    
    //handles the gesture recognizer for when a picture is tapped
    
    func profilePictureGestureSetup(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(gesture)
        profileImageView.profilePageImageView()
    }
    
    //handles the gesture recognizer for when the status textfield is tapped
    func statusTextFieldGestureSetup(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(statusTextFieldTapped))
        statusTextField.isUserInteractionEnabled = true
        statusTextField.addGestureRecognizer(gesture)
       
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
    
    @objc func statusTextFieldTapped(textfield:UITextField){
        print("status Textfield Tapped")
    }
    
    
    func presentCameraRoll (sender : UIAlertAction!){
        let cameraRoll = UIImagePickerController()
        cameraRoll.delegate = self
        cameraRoll.sourceType = .photoLibrary
        cameraRoll.allowsEditing = true
        self.present(cameraRoll, animated: true, completion: nil)
        
        
    }
    
    
    func deleteImage (sender : UIAlertAction!){
        profileImageView.image = defaultImage
        //Constants.profilePage.globalProfileImage = nil
        //remove image from firebase
        deleteProfilePicture()
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            profileImageView.image = image
            Constants.profilePage.profileImageState = true
            Constants.profilePage.globalProfileImage = image
            
            dismiss(animated: true, completion: nil)
        }
        //sets image to be the edited image.
        else if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            profileImageView.image = image
            Constants.profilePage.profileImageState = true
            Constants.profilePage.globalProfileImage = image
            
            dismiss(animated: true, completion: nil)
        }
        
        let data = Constants.profilePage.globalProfileImage!.pngData()!
        saveProfilePicture(data: data)
        
        


        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func setImage(){
        FireService.sharedInstance.getProfilePicture(user: globalUser.toFireUser) { (result) in
            switch result{
                
            case .success(let url):
//                self.profileImageView.af_setImage(withURL: url)
                self.profileImageView.loadImages(urlString: url.absoluteString, mediaType: Constants.profilePage.profileImageType)
                
            case .failure(_):
                print("failed to set image url")
            }
            
        }
    }
    
    
    func deleteProfilePicture(){
         profileImageView.isUserInteractionEnabled = false
        FireService.sharedInstance.DeleteProfilePicture(user: globalUser.toFireUser) { (result) in
            switch result{
                
            case .success(let bool):
                if bool{
                    Constants.profilePage.globalProfileImage = self.defaultImage
                    Constants.profilePage.profileImageState = true
                    self.profileImageView.isUserInteractionEnabled = true
                    return
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Could not delete", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                 self.profileImageView.isUserInteractionEnabled = true
            }
        }
        
        
        
    }
    
    func saveProfilePicture(data : Data){
         self.profileImageView.isUserInteractionEnabled = false
        FireService.sharedInstance.saveProfilePicture(data: data, user: globalUser.toFireUser) { (result) in
            switch result {
            case .success(_):
                print("sucess")
                let image = UIImage(data: data)!
                Constants.profilePage.globalProfileImage = image
                Constants.profilePage.profileImageState = true
                 self.profileImageView.isUserInteractionEnabled = true
            case .failure(_):
                print("falure")
            }
        }
        
    }
    //updates the background color for the tableview and nav bar.
    func updateBackgroundViews(){
        DispatchQueue.main.async {
            self.view.darkmodeBackground()
            self.navigationController?.navigationBar.darkmodeBackground()
    
            self.navigationBarBackgroundHandler()
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
    
    
    @IBAction func signOut(_ sender: Any) {
        
        
        
    }
    
    
}
