//
//  ProfileVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/7/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var nameHeader: UILabel!
    @IBOutlet weak var emailHeader: UILabel!
    @IBOutlet weak var statusHeader: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
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
       
    }

}
