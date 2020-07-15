//
//  ProfileVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/7/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileVC: UIViewController,UIPickerViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setImage()
        updateViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultImage = profileImageView.image
        profilePictureGestureSetup()
        updateViews()
        statusTextFieldGestureSetup()
       
        
        // Do any additional setup after loading the view.
        
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
        nameTextField.text = globalUser?.name
        emailTextField.text = globalUser?.email
        
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
        let action3 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
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
        cameraRoll.allowsEditing = false
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
        
        let data = Constants.profilePage.globalProfileImage!.pngData()!
        saveProfilePicture(data: data)
        


        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func setImage(){
        FireService.sharedInstance.getProfilePicture(user: globalUser!) { (result) in
            switch result{
                
            case .success(let url):
//                self.profileImageView.af_setImage(withURL: url)
                
                self.profileImageView.af.setImage(withURL: url, cacheKey: nil, placeholderImage: nil, serializer: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.global(), imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: true) { (reponse) in

                    switch reponse.result {
                    case .success(let image):
                        Constants.profilePage.globalProfileImage = image
                        Constants.profilePage.profileImageState = true
                        self.profileImageView.isUserInteractionEnabled = true
                    case .failure(let error):
                        print(error.localizedDescription)
                         self.profileImageView.isUserInteractionEnabled = true
                    }

                }
                
                
            case .failure(_):
                print("failed to set image url")
            }
            
        }
    }
    
    
    func deleteProfilePicture(){
         profileImageView.isUserInteractionEnabled = false
        FireService.sharedInstance.DeleteProfilePicture(user: globalUser!) { (result) in
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
        FireService.sharedInstance.saveProfilePicture(data: data, user: globalUser!) { (result) in
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
    
    
    @IBAction func signOut(_ sender: Any) {
        
        
        
    }
    
    
}
