//
//  ProfileVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/7/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePictureGestureSetup()
        updateViews()
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
        
        statusTextField.rightView = textFieldIcon2
        statusTextField.rightViewMode = UITextField.ViewMode.unlessEditing
        statusTextField.profilePageTextFields(type: Constants.profilePage.textfields)
        
        emailTextField.rightView = textFieldIcon3
        emailTextField.rightViewMode = UITextField.ViewMode.unlessEditing
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
    
    @objc func profileImageTapped(){
        let cameraRoll = UIImagePickerController()
        cameraRoll.delegate = self
        cameraRoll.sourceType = .photoLibrary
        cameraRoll.allowsEditing = false
        self.present(cameraRoll, animated: true, completion: nil)
        

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            profileImageView.image = image
            Constants.profilePage.profileImageState = true
            Constants.profilePage.globalProfileImage = image
           // profileImageView.contentMode = .scaleAspectFit
            
            dismiss(animated: true, completion: nil)
            
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signOut(_ sender: Any) {
        
        
        
    }
    
    
}
