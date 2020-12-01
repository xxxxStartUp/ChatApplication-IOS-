//
//  SignInVC.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var welcomeHeader: UILabel!
    @IBOutlet weak var alreadyHaveAnAccountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        updateViews()
    }
    
    @IBAction func SignUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Login(_ sender: Any) {
        var isError = false
        if(passwordTextField.text?.lowercased() == ""){
            isError = true
            self.snackbar("Password is Mandatory")
        }
        if(emailTextField.text?.lowercased() == ""){
            isError = true
            self.snackbar("Email is Mandatory")
        }
        if(!isError){
            login()
        }
    }
    
    
    
    
    
    func login() -> Void {
        if let email = emailTextField.text, let password = passwordTextField.text{
            //Need to complete validate class and functions in class before using it
            if Validate.isPasswordValid(password) && Validate.isValidEmail(email){
                FireService.sharedInstance.signIn(email: email, password: password) { (completed) in
                    if completed{
                        FireService.sharedInstance.searchOneUserWithEmail(email: email) { (user, error) in
                            globalUser = user
                            if let user = user{
                                FireService.sharedInstance.addCustomData(data: ["deviceToken":Constants.deviceTokenKey.load()],
                                                                         user: user)
                                { (error, completion) in
                                    if let error = error{
                                        print("error \(error)")
                                    }
                                }
                            }
                        }

                        print("Signed In Successfully")
                        if let displaymode = UserDefaults.standard.value(forKey: "displayModeSwitch") as? Bool{
                            Constants.settingsPage.displaySwitch?.isOn = displaymode
                        }
                        else{
                            UserDefaults.standard.setValue(false, forKey: "displayModeSwitch")
                        }
                        
                        let controller =  UIAlertController.alertUser( title: "Sucess", message: "you signed in sucesfully", whatToDo: "Go to home screen")
                        self.present(controller, animated: true) {
                            
                            self.checkForUser()
                        }
                        
                    }
                    else{
                        let controller =  UIAlertController.alertUser( title: "error", message: "Firebase Error Signing in", whatToDo: "Try again")
                        self.present(controller, animated: true, completion: nil)
                        
                    }
                }
                
            }
            else{
                
                let controller =  UIAlertController.alertUser( title: "Error with email or password", message: "Wrong email or password format", whatToDo: "Try again")
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    func updateViews(){
        loginButton.onBoardingPageButton(type: Constants.onBoardingPage.filledButton)
        signupButton.onBoardingPageButton(type: Constants.onBoardingPage.notFilledButton)
        welcomeHeader.onBoardingPageHeaderLabels()
        emailLabel.onBoardingPageSubHeaderLabels(type: Constants.onBoardingPage.emailSubHeader)
        passwordLabel.onBoardingPageSubHeaderLabels(type: Constants.onBoardingPage.passwordSubHeader)
        alreadyHaveAnAccountLabel.onBoardingPageSubHeaderLabels(type: Constants.onBoardingPage.alreadyHaveAnAccoutSubHeader)
        
    }
    
    
}



extension UIAlertController {
    
    
    static func alertUser(title : String , message : String , whatToDo : String) -> UIAlertController {
        
        let alertControler = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertControler.addAction(UIAlertAction(title: whatToDo, style: .cancel))
        return alertControler
        
    }
}


extension UIViewController {
    
    
    func goToTab(){
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "MainTabStoryboard", bundle: nil).instantiateInitialViewController()!
            self.view.window?.rootViewController = vc
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func goToLogin(){
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "SignUpSB", bundle: nil).instantiateInitialViewController()!
            self.view.window?.rootViewController = vc
            self.view.window?.makeKeyAndVisible()
        }
    }
    
}
