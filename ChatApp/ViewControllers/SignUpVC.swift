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
        updateViews()
        checkForUser()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.loginTabStoryBoardSegue, sender: self)
    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        signUp()
        
        //self.goToTab()
        
        
    }
    
    

    
    func signUp(){
        if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text{
            //Need to complete validate class and functions in class before using it
            if Validate.isPasswordValid(password) && Validate.isValidEmail(email){
                
                let user = FireUser(userID: "1", userName: name, userEmail: email, creationDate: Date())
                
                
                FireService.sharedInstance.SignUp(email: email, password: password) { (completed) in
                    if completed{
                        
                        FireService.sharedInstance.addData(user:user) { (error, sucess) in
                            
                            
                            if sucess{
                                globalUser = user
                                let controller =  UIAlertController.alertUser( title: "Sucess", message: "you are signed up", whatToDo: "good job!")
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
    func updateViews(){
        helloLabel.onBoardingPageHeaderLabels()
        emailLabel.onBoardingPageSubHeaderLabels(type: Constants.onBoardingPage.emailSubHeader)
        nameLabel.onBoardingPageSubHeaderLabels(type: Constants.onBoardingPage.nameSubHeader)
        passwordLabel.onBoardingPageSubHeaderLabels(type: Constants.onBoardingPage.passwordSubHeader)
        signupButton.onBoardingPageButton(type: Constants.onBoardingPage.filledButton)
        loginButton.onBoardingPageButton(type: Constants.onBoardingPage.notFilledButton)
        alreadyHaveAnAccount.onBoardingPageSubHeaderLabels(type: Constants.onBoardingPage.alreadyHaveAnAccoutSubHeader)
    }
    
}


extension UIViewController {
    // to user this just type: let user = UIViewController.user
    
    var user : FireUser? {
        return  globalUser
    }
    
    
    func checkForUser(){
        FireService.sharedInstance.getCurrentUser { (user) in
            if let email = user?.email{
                
                FireService.sharedInstance.getCurrentUserData(email: email) { (fireUser, error) in
                    if let fireUser = fireUser{
                        globalUser = fireUser
                        self.goToTab()
                    }
                    
                }
            }
        }
    }
    

}


