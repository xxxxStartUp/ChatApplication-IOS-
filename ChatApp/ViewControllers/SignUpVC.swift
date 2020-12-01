//
//  SignUpVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 6/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var alreadyHaveAnAccount: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let codableMessage = CodableMessage(message: "message")
        let exampleCodableUser = codableUser(name: "codableEgb", message: codableMessage)
        FireService.sharedInstance.createCodableUser(for: exampleCodableUser)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.loginTabStoryBoardSegue, sender: self)
    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        var isError = false
        if(passwordTextField.text?.lowercased() == ""){
            isError = true
            self.snackbar("Password is Mandatory")
        }
        if(emailTextField.text?.lowercased() == ""){
            isError = true
            self.snackbar("Email is Mandatory")
        }
        if(nameTextField.text?.lowercased() == ""){
            isError = true
            self.snackbar("Name is Mandatory")
        }
        if(!isError){
            signUp()
        }
    }
    
    

    
    func signUp(){
        if let name = nameTextField.text, let email1 = emailTextField.text, let password = passwordTextField.text{
            let email = email1.lowercased().replace(this: " ", with: "")
            //Need to complete validate class and functions in class before using it
            if Validate.isPasswordValid(password) && Validate.isValidEmail(email){
                let id = UUID().uuidString
                let deviceToken = Constants.deviceTokenKey.load()
                let user = FireUser(userID: id, token: deviceToken, userName: name, userEmail: email,profileImageUrl: "",status: "" , creationDate: Date())
                FireService.sharedInstance.SignUp(email: email, password: password) { (completed) in
                    if completed{
                        
                        FireService.sharedInstance.addData(user:user) { (error, sucess) in
                            
                            
                            if sucess{
                                globalUser = user
                                if let displaymode = UserDefaults.standard.value(forKey: "displayModeSwitch") as? Bool{
                                    Constants.settingsPage.displaySwitch?.isOn = displaymode
                                }
                                else{
                                    UserDefaults.standard.setValue(false, forKey: "displayModeSwitch")
                                }
                                let controller =  UIAlertController.alertUser( title: "Welcome! \(name)", message: "you are signed up", whatToDo: "Continue")
                                self.present(controller, animated: true) {
                                    self.goToTab()
                                }
                            }else{
                                let controller =  UIAlertController.alertUser( title: "error", message: error?.localizedDescription ?? "firebase error in save function", whatToDo: "Try again")
                                self.present(controller, animated: true, completion: nil)
                                
                            }
                        }
                        
                        
                        
                    }
                    else{
                        let controller =  UIAlertController.alertUser( title: "error", message: "Firebase Error Signing in", whatToDo: "Try again")
                        self.present(controller, animated: true, completion: nil)
                        print("Error occured while signing up")
                    }
                }
                
            }
            else{
                let controller =  UIAlertController.alertUser( title: "error", message: "Error with email and passowrd validator ", whatToDo: "Try again")
                self.present(controller, animated: true, completion: nil)
            }
        }
        
    }
}

